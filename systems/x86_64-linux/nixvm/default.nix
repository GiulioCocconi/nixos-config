{ config, lib, ... }:
with lib;

{

  imports = [ ./hardware.nix ];

  cogisys = {

    virtualmachine = enabled;

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

  system.stateVersion = "23.05";

}
