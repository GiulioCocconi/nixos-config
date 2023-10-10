{ config, lib, pkgs, ... }:
with lib;
with lib.cogisys;

{

  imports = [ ./hardware.nix ];

  cogisys = {
    suites = {
      common = enabled;
      scientificWriting = enabled;
    };

    suites.development = {
      enable = true;
      languages = {
        commonLisp = {
          enable = true;
          sbclPkgs = with pkgs.sbclPackages; [ kons-9 ];
        };
      };
    };

    system.networking.wifi = enabled;

    emacs = enabled;

    system.gui = enabled;

  };

  users.users = mkUsers [{
    userName = "giulio";
    fullName = "G. Cocconi";
    isAdmin = true;
    packages = with pkgs; [ obsidian racket ];
  }];

  system.stateVersion = "23.05";

}
