{ inputs, pkgs, lib, ... }:
let
  hostname = "wip";
  gateway = lib.getExe inputs.gateway.packages.${pkgs.system}.default;
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

  systemd.services.gateway = {
    description = "Run gateway";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = ''${gateway} --features "tracker sonify"'';
      Restart = "on-failure";
    };
  };
}
