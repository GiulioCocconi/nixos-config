{ lib, options, config, ... }:
with lib;

let
  cfg = config.cogisys.tools.git;
in
{
  options.cogisys.tools.git = with types; {
    enable = mkBoolOpt false "Enable git.";
  };

  # TODO: Make multiuser config!
  config = mkIf cfg.enable {
    programs.git = {
	  enable = true;

	  config = {
        init = { defaultBranch = "main"; };
        pull = { rebase = true; };
        push = { autoSetupRemote = true; };
        core = { whitespace = "trailing-space,space-before-tab"; };
	  };
	};

	environment.shellAliases.ggrep = "git grep -n";

  };
}
