{ lib, options, config, pkgs, ...}:
with lib;

let
  cfg = config.cogisys.suites.common;
in
{
  options.cogisys.suites.common = with types; {
    enable = mkBoolOpt false "Enable common configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
	  pkgs.wget
	  pkgs.bat
      pkgs.tree
	  pkgs.fzf
	  pkgs.neovim
	  pkgs.killall
	  pkgs.unzip
	];

    hardware.bluetooth.enable = true;


	cogisys = {
	  nix = enabled;
      awesome = enabled;
      tools = {
	    git = enabled;
		zsh = enabled;
		starship = enabled;
	  };

	  services = {
	    openssh = enabled;
		tailscale = enabled;
	  };

	  system = {
	    boot = enabled;
	    locale = enabled;
		networking = enabled;
		printing = enabled;
	    audio = enabled;
	  };
	};

    environment.shellAliases = {
	  cls = "clear";
	  mkdir = "mkdir -p";
	};

  };
}
