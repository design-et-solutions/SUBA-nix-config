{ inputs, pkgs, ... }:
let
  hostname = "wip";
  gateway = "${inputs.gateway.packages.${pkgs.system}.default}/bin/gateway";
  tracker = "${inputs.tracker.packages.${pkgs.system}.default}/bin/tracker";
  sonify = "${inputs.sonify.packages.${pkgs.system}.default}/bin/sonify";
in {
  imports = [
    inputs.disko.nixosModules.disko
    ../../nixos/common
    ../../nixos/users/wallago.nix
    ../../nixos/feat/disko-configuration.nix
    ../../nixos/feat/sound.nix
    ./hardware-configuration.nix
  ];

  disk.path = "/dev/nvme0n1";

  networking = {
    hostName = "${hostname}";
    firewall.allowedTCPPorts = [ 8080 ];
  };

  systemd.services = {
    gateway = {
      description = "Run gateway";
      after = [ "network.target" "tracker.service" "sonify.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${gateway}";
        Environment = [
          "RUST_LOG=info"
          ''APP_HOST="0.0.0.0"''
          "APP_PORT=8080"
          "TRACKER_ENABLE=true"
          ''TRACKER_HOST="0.0.0.0"''
          "TRACKER_PORT=50200"
          "SONIFY_ENABLE=true"
          "SSL_CRT_FILE=./fullchain.crt"
          "SSL_KEY_FILE=./gateway.key"
        ];
        Restart = "on-failure";
      };
    };

    tracker = {
      description = "Run tracker";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${tracker}";
        Environment =
          [ "RUST_LOG=info" ''APP_HOST="0.0.0.0"'' "APP_PORT=50200" ];
        Restart = "on-failure";
      };
    };

    sonify = {
      description = "Run sonify";
      after = [ "network.target" "tracker.service" "pulseaudio.service" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        User = "wallago";
        ExecStart = "${sonify}";
        Environment = [
          "RUST_LOG=info"
          ''APP_HOST="0.0.0.0"''
          ''TRACKER_HOST="0.0.0.0"''
          "TRACKER_PORT=50200"
          "XDG_RUNTIME_DIR=/run/user/1001"
        ];
        Restart = "on-failure";
      };
    };
  };
}
