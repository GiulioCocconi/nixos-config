# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ config, lib, cogisysLib, ... }:
with lib;
with cogisysLib;

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
