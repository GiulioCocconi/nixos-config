{ config, lib, ... }:
with lib;
with lib.cogisys;

{

  imports = [ ./hardware.nix ];

  cogisys = {

    virtualmachine = enabled;

    suites = {
      common = enabled;
      development = enabled;
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
