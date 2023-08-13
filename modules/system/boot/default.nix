{lib, config, ...}:


with lib;
let
  cfg = config.cogisys.system.boot;
in
  {
    options.cogisys.system.boot = with types; {
<<<<<<< HEAD
      enable = mkEnableOption "booting.";
      dualBoot = mkBoolOpt false "Is the system dual-booting?"; # If true enable osprober
      rootFilesystem = mkOpt (enum ["ext4" "zfs" "btrfs"]) "ext4";
=======
      enable = mkBoolOpt false "Enable booting.";
      dualBoot = mkBoolOpt false "Is the system dual-booting?";
>>>>>>> parent of 2a5cb23 (Using mkEnableOption in all modules)
    };

    config = mkMerge [
      (mkIf cfg.enable {
        boot = {
          loader = {
          # TODO!
        };
      };
      supportedFilesystems = [ cfg.rootFilesystem ];
    })
    (mkIf (cfg.enable && cfg.dualBoot) {
        #TODO: Enable osprober
      })
    ];
  }
