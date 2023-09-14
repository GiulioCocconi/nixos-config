{ config, lib, pkgs, ... }:
with lib;
with lib.cogisys;

{

  imports = [ ./hardware.nix ];

  cogisys = {
    suites = {
      common = enabled;
      development = enabled;
      scientificWriting = enabled;
    };

    system.networking.wifi = enabled;

    emacs = enabled;

    system.gui = enabled;

  };

  users.users = mkUsers [{
    userName = "giulio";
    fullName = "G. Cocconi";
    isAdmin = true;
    packages = with pkgs; [ obsidian ];
  }];

  system.stateVersion = "23.05";

}
