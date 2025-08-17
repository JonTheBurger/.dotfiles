{ pkgs, ... }:
{
  services.minecraft-server = {
    enable = true;
    dataDir = "/var/homelab/minecraft";
    eula = true;
    openFirewall = true;
    declarative = true;
    serverProperties = {
      server-port = 25565;
      difficulty = "normal";
      gamemode = "survival";
      force-gamemode = true;
      max-players = 5;
      pvp = true;
      # level-name = "world-2025";
      # generator-settings = {};
      motd = "NixOS Minecraft server!";
      white-list = false;
    };
    # package = pkgs.minecraft-server;
    package = pkgs.minecraft-server.overrideAttrs (old: {
      version = "1.21.8";
      src = pkgs.fetchurl {
        url = "https://piston-data.mojang.com/v1/objects/6bce4ef400e4efaa63a13d5e6f6b500be969ef81/server.jar";
        sha256 = "2349d9a8f0d4be2c40e7692890ef46a4b07015e7955b075460d02793be7fbbe7";
      };
    });
    # jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC -XX:+CMSIncrementalPacing -XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 -XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
  };
}
