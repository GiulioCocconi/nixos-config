# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ config, lib, cogisysLib, pkgs, ... }:
with lib;
with cogisysLib;

{

  imports = [ ./hardware.nix ];

  cogisys = {
    suites.scientificWriting = enabled;
    suites.development = enabled;

    system.networking.wifi = enabled;

    apps.emacs = enabled;
    system.gui = enabled;
    tools.gnupg = enabled;

  };

  users.users = mkUsers [{
    userName = "giulio";
    fullName = "G. Cocconi";
    isAdmin = true;
    packages = with pkgs; [ geogebra ];
  }];

  virtualisation.virtualbox.host.enable = true;



  system.stateVersion = "23.05";

}
