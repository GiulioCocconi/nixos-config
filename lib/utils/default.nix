# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{lib, ...}:

with lib; rec {
  writeFileService = {file, text}: {
    wantedBy = [ "multi-user.target" ];
    startLimitBurst = 5;
    startLimitIntervalSec = 1;
    script = ''
      echo ${escapeShellArg text} > ${escapeShellArg file}
    '';
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
    };
  };
}
