# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{lib, ...}:

with lib; rec {
  mkUsers = list:
    builtins.listToAttrs (builtins.map (user:
      nameValuePair user.userName {
        isNormalUser = true;
        description = user.fullName;
        initialPassword = user.password or "";

        extraGroups = [ "video" "audio" "jackaudio" ]
                      ++ (optionals user.isAdmin [ "wheel" ])
                      ++ (user.extraGroups or []);

        packages = user.packages or [];

        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHjgpR2oQ0LIjJil4hmPhIsu1Ua6JKGUHEPyasfV/zIp"
        ] ++ (user.sshAuthKey or []);


      })
      list);
}


