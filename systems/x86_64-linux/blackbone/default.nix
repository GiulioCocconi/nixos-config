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

  users.users = mkUsers [{
    userName = "giulio";
    fullName = "G. Cocconi";
    isAdmin = true;
  }];

  system.stateVersion = "23.05";

}
