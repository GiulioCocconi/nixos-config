{lib, options, config, ...}:
with lib;

let
  cfg = config.cogisys.tools.starship;
in
  {
    options.cogisys.tools.starship = with types; {
      enable = mkEnableOption "starship prompt";
    };

    config = mkIf cfg.enable {
      programs.starship = {
        enable = true;
        settings = (builtins.fromTOML (builtins.readFile ./starship.toml));
      };
    };
  }
