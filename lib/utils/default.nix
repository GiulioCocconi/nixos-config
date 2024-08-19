# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{lib, ...}:
let
  pkgs = import <nixpkgs> {}; # Ugly fix, should be passed as an attribute
in 
with lib; rec {
  writeFileService = {file, text}: {
    wantedBy = [ "multi-user.service" ];
    startLimitBurst = 5;
    startLimitIntervalSec = 1;
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
      ExecStart = "${pkgs.runtimeShell} -c 'echo ${text} > ${file}'";
    };
  };
}
