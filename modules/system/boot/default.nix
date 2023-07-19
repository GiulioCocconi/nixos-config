{lib, config, ...}:


with lib;
let
  cfg = config.cogisys.system.boot;
in
  {
    options.cogisys.system.boot = with types; {
      enable = mkBoolOpt false "Enable booting.";
      dualBoot = mkBoolOpt false "Is the system dual-booting?";
    };

    config = mkIf cfg.enable {
      boot.loader = {
      # TODO!
    };
  };
}
