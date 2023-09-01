{ lib, config, options, pkgs, ... }:
with lib;

let
  cfg = config.cogisys.tools.terminal;
  gui = config.cogisys.system.gui;
  light = config.cogisys.light;
in
  {
    options.cogisys.tools.terminal = with types; {
      enable = mkEnableOption "terminal";
      package = mkOption {
        type = types.package;
        default = (if light.memory then pkgs.st else pkgs.kitty);
        defaultText = "if light.memory then pkgs.st else pkgs.kitty";
        description = "The package to be used as terminal.";
      };
    };

    config = mkMerge [
      (mkIf cfg.enable {
        environment.systemPackages = [cfg.package];
        environment.variables.TERMINAL = cfg.package.mainProgram or cfg.package.pname;
      })
      (mkIf (cfg.enable && (cfg.package.pname == "kitty")) {
        environment.variables.KITTY_CONFIG_DIRECTORY = "/etc/kitty";
        environment.etc."kitty/kitty.conf".text = ''
        # /etc/kitty/kitty.conf: DO NOT EDIT -- this file has been generated automatically.

        '' + (builtins.readFile ./kitty.conf);
  })
];
  }
