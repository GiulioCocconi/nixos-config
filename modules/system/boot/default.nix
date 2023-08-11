{lib, config, ...}:


with lib;
let
  cfg = config.cogisys.system.boot;
in
  {
    options.cogisys.system.boot = with types; {
      enable = mkEnableOption "booting.";
      dualBoot = mkBoolOpt false "Is the system dual-booting?"; # If true enable osprober
    };

    config = mkIf cfg.enable {
      boot.loader = {
      # TODO!
    };
  };
}
