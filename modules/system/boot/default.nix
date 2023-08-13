{lib, config, ...}:


with lib;
let
  cfg = config.cogisys.system.boot;
in
  {
    options.cogisys.system.boot = with types; {
      enable = mkEnableOption "booting.";
      dualBoot = mkBoolOpt false "Is the system dual-booting?"; # If true enable osprober
      rootFilesystem = mkOpt (enum ["ext4" "zfs" "btrfs"]) "ext4" "Filesystem of root";
    };

    config = mkMerge [
      (mkIf cfg.enable {
        boot = {
          loader = {
          # TODO!
        };
        supportedFilesystems = [ cfg.rootFilesystem ];
      };
    })
    (mkIf (cfg.enable && cfg.dualBoot) {
        #TODO: Enable osprober
      })
    ];
  }
