{ pkgs, ... }:
{
  services.nexus = {
    enable = true;
    package = pkgs.nexus.overrideAttrs (oldAttrs: rec {
      version = "3.83.0-08";
      sourceRoot = "${oldAttrs.pname}-${version}";
      src = pkgs.fetchurl {
        url = "https://download.sonatype.com/nexus/3/nexus-${version}-linux-x86_64.tar.gz";
        sha256 = "29ae07b8290f667973008551fa38d9d5cbc793855c01a70446d220bdc0cb8ac1";
      };
      patches = [];
      postPatch = ''
        substituteInPlace bin/nexus.vmoptions \
          --replace-fail ../sonatype-work /var/lib/sonatype-work \
          --replace-fail =. =$out
      '';
      meta.knownVulnerabilities = [];
    });
  };
}
