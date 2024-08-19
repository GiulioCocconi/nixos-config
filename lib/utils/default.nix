# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{lib, ...}:

with lib; rec {
  writeFileService = {file, text}: {
    wantedBy = [ "multi-user.service" ];
    startLimitBurst = 5;
    startLimitIntervalSec = 1;
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
      ExecStart = "$bash -c 'echo ${text} > ${file}'";
    };
  };
}
