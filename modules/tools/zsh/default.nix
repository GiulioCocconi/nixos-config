{ lib, options, config, pkgs, ...}:
with lib;

let
  cfg = config.cogisys.tools.zsh;
in
{
  options.cogisys.tools.zsh = with types; {
    enable = mkBoolOpt false "Enable zsh.";
  };

  config = mkIf cfg.enable {
    programs.zsh = {
	  enable = true;
	  syntaxHighlighting.enable = true;
	  autosuggestions.enable = true;
	};

	users.defaultUserShell = pkgs.zsh;
  };
}
