# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ config, lib, ... }:
with lib;
with lib.cogisys;

{

  imports = [ ./hardware.nix ];

  cogisys = {

    virtualmachine = enabled;

    suites.development = enabled;

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
