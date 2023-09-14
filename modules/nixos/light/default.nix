{lib, config, options, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.light;
in
{
  options.cogisys.light = {
    enable = mkEnableOption "light system";
    memory = mkBoolOpt cfg.enable "Set to true if system has little memory";
    storage = mkBoolOpt cfg.enable "Set to true if system has little storage space";
  };
}
