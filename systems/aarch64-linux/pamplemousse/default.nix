{ config, lib, ... }:
with lib;
with lib.cogisys;

{

  imports = [ ./hardware.nix ];

  cogisys = {
    raspberry = enabled;

    suites = {
      development = enabled;
      scientificWriting = enabled;
    };

    system.networking.wifi = enabled;
    system.gui = enabled;

  };

  users.users = mkUsers [{
    userName = "giulio";
    fullName = "G. Cocconi";
    isAdmin = true;
  }];

  system.stateVersion = "23.05";

}
