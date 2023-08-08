{ config, lib, ... }:
with lib;

{

  imports = [ ./hardware.nix ];

  cogisys = {
    virtualmachine = enabled;
  };

  users.users = mkUsers [{
    userName = "giulio";
    fullName = "G. Cocconi";
    isAdmin = true;
  }];

  system.stateVersion = "23.05";

}
