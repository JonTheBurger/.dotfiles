{ config, lib, pkgs, ... }:
# TODO: Unify sonar/sonarqube users and database names
# https://docs.sonarsource.com/sonarqube-server/latest/server-installation/network-security/securing-behind-proxy/

let
  cfg = config.services.sonarqube;
in rec
{
  options.services.sonarqube = {
    enable = lib.mkEnableOption "SonarQube server";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.sonarqube;
    };

    jdbcUrl = lib.mkOption {
      type = lib.types.str;
      default = "jdbc:postgresql://localhost/sonarqube?currentSchema=public";
      description = ''
        JDBC connection string for SonarQube database.
        Typically looks like: jdbc:postgresql://host:port/database.
        If null, a suitible default will be constructed.
        If you change currentSchema you must set schemaName to match.
      '';
    };

    jdbcUser = lib.mkOption {
      type = lib.types.str;
      default = "sonarqube";
      description = "Database username for SonarQube. A user with the same name will be created.";
    };

    jdbcPasswordFile = lib.mkOption {
      type = lib.types.path;
      default = null;
      example = "/etc/secrets/sonarqube-db-password";
      description = ''
        Path to a file containing the database password.
        This is preferred over putting the password in plain text.
      '';
    };

    extraProperties = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {};
      description = ''
        Extra key-value pairs to add to sonar.properties.
        Useful for custom settings like LDAP or plugins.
      '';
    };

    schemaName = lib.mkOption {
      type = lib.types.str;
      default = "public";
      description = "Database schema name SonarQube.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.jdbcPasswordFile != null;
        message = "services.sonarqube.jdbcPasswordFile must be set when SonarQube is enabled.";
      }
    ];

    boot.kernel.sysctl = {
      "vm.max_map_count" = lib.mkDefault 524288;
      "fs.file-max" = lib.mkDefault 131072;
    };

    users.users.sonarqube = {
      isSystemUser = true;
      group = "sonarqube";
    };
    users.groups.sonarqube = {};

    systemd.services.sonarqube = {
      description = "SonarQube Service";
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/sonar.sh start";
        ExecStop = "${cfg.package}/bin/sonar.sh stop";
        User = "sonarqube";
        LimitNOFILE = 131072;
        LimitNPROC = 8192;
        LoadCredential = [
          "jdbc-password:${cfg.jdbcPasswordFile}"
        ];
      };
        # TODO: Permissions of /var/lib/sonarqube/conf?
        # ${if cfg.jdbcUrl != null then
        #   "sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube?currentSchema=${cfg.schemaName}"
        # else
        #   "sonar.jdbc.url=${cfg.jdbcUrl}"
        # }
      preStart = ''
        set -e
        mkdir -p /var/lib/sonarqube/conf
        cat > /var/lib/sonarqube/conf/sonar.properties <<EOF
        sonar.jdbc.url=${cfg.jdbcUrl}
        sonar.jdbc.username=${cfg.jdbcUser}
        sonar.jdbc.password=$(cat "$CREDENTIALS_DIRECTORY/jdbc-password"
        ${lib.concatStringsSep "\n"
          (map (n: "${n}=${cfg.extraProperties.${n}}")
            (builtins.attrNames cfg.extraProperties)
          )
        }
        EOF

        # Load the SonarQube DB password from systemd secret
        SONAR_DB_PASSWORD=$(cat "$CREDENTIALS_DIRECTORY/sonarqube-db-password")
        # TODO: Get postgres credentials
        # Connect as postgres superuser
        PSQL="psql -v ON_ERROR_STOP=1 -U postgres"
        # Check if the database exists
        if ! $PSQL -tAc "SELECT 1 FROM pg_database WHERE datname='sonarqube'" | grep -q 1; then
          echo "Creating SonarQube database and user..."

          # Create user
          $PSQL -c "CREATE USER ${cfg.jdbcUser} WITH PASSWORD '$SONAR_DB_PASSWORD';"

          # Create database
          $PSQL -c "CREATE DATABASE sonarqube WITH ENCODING 'UTF8' TEMPLATE template0;"

          # Grant privileges on database
          $PSQL -c "GRANT CONNECT ON DATABASE sonarqube TO ${cfg.jdbcUser};"
          $PSQL -c "GRANT TEMPORARY ON DATABASE sonarqube TO ${cfg.jdbcUser};"

          # Create schema inside the database
          $PSQL -d sonarqube -c "CREATE SCHEMA IF NOT EXISTS ${cfg.schemaName};"
          $PSQL -d sonarqube -c "GRANT USAGE, CREATE ON SCHEMA ${cfg.schemaName} TO ${cfg.jdbcUser};"
          $PSQL -d sonarqube -c "GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ${cfg.schemaName} TO ${cfg.jdbcUser};"
          $PSQL -d sonarqube -c "ALTER DEFAULT PRIVILEGES IN SCHEMA ${cfg.schemaName} GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO sonar;"
        else
          echo "SonarQube database already exists."
        fi
      '';
    };
  };
}

# systemd.services.sonarqube.serviceConfig = {
#   ExecStartPre = ''
#     set -e
#
#   '';
# };
