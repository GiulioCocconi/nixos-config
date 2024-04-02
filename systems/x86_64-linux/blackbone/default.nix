# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:
with lib;
with lib.cogisys;

{

  imports = [ ./hardware.nix ];

  cogisys = {
    suites.scientificWriting = enabled;
    suites.development = enabled;

    system.networking.wifi = enabled;

    apps.emacs = enabled;
    system.gui = enabled;

  };

  users.users = mkUsers [{
    userName = "giulio";
    fullName = "G. Cocconi";
    isAdmin = true;
    packages = with pkgs; [ mathematica racket libsForQt5.kdenlive qucs-s ];
  }];

  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "23.05";

}
