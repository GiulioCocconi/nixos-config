{lib, ...}:

with lib; rec {
  mkUsers = list:
    builtins.listToAttrs (builtins.map (user:
      nameValuePair user.userName {
        isNormalUser = true;
        description = user.fullName;
        initialPassword = user.password or "";

        extraGroups = [ "video" "audio" ]
          ++ (optionals (user.isAdmin or false) [ "wheel" ])
          ++ (user.extraGroups or []);

        packages = user.packages or [];


      })
    list);
}


