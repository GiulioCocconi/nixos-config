# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:
with lib;
with lib.cogisys;

{

  imports = [ ./hardware.nix ];

  cogisys = {
    suites.development = enabled;
    tools.gnupg = enabled;
    system.gui = disabled;
    system.audio = disabled;
    system.printing = disabled;

  };

  users.users = mkUsers [{
    userName = "giulio";
    fullName = "G. Cocconi";
    isAdmin = true;
    packages = with pkgs; [];
  }];

  system.stateVersion = "24.11";

}
