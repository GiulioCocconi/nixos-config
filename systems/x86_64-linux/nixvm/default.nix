{ config, lib, ... }:
with lib;

{

  imports = [ ./hardware.nix ];

  cogisys = {

    suites = {
      common = enabled;
      development = enabled;
      scientificWriting = enabled;
    };

    system.networking.wifi = enabled;
    system.gui = enabled;

  };

  users.users.giulio = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  virtualisation.vmware.guest.enable = true;
  system.stateVersion = "23.05";

}
