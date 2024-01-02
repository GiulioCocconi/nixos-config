{ config, lib, pkgs, ... }:
with lib;
with lib.cogisys;

{

  imports = [ ./hardware.nix ];

  cogisys = {
    suites.scientificWriting = enabled;

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

    apps.emacs = enabled;
    system.gui = enabled;

  };

  users.users = mkUsers [{
    userName = "giulio";
    fullName = "G. Cocconi";
    isAdmin = true;
    packages = with pkgs; [ racket mathematica libsForQt5.kdenlive ];
  }];

  system.stateVersion = "23.05";

}
