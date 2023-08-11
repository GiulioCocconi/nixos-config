{ lib, options, config, pkgs, ...}:
with lib;

let
  cfg = config.cogisys.tools.zsh;
  nix = config.cogisys.nix;
in
  {
    options.cogisys.tools.zsh = with types; {
      enable = mkEnableOption "zsh";
    };

    config = mkMerge [
      (mkIf cfg.enable {
        programs.zsh = {
          enable = true;
          syntaxHighlighting.enable = true;
          autosuggestions.enable = true;
        };

        # TODO: Add autopairs plugin

        users.defaultUserShell = pkgs.zsh;

      })
      (mkIf (nix.enable && cfg.enable) {
        environment.shellAliases.nix-shell = "nix-shell --command zsh";
      })
    ];
  }
