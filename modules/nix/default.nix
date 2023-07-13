{ lib, options, config, ... }:
with lib;

let
  cfg = config.cogisys.nix;
in
{
  options.cogisys.nix = with types; {
    enable = mkBoolOpt false "Enable nix management.";
  };

  config = mkIf cfg.enable {
    nix = {
	  settings = {
	    experimental-features = [ "nix-command" "flakes" ];
		http-connections = 50;
		warn-dirty = false;
		auto-optimise-store = true;
	  };

	  gc.automatic = true;
	  gc.dates = "weekly";
	  gc.options = "--delete-older-than 30d";
	};

    system.autoUpgrade.enable = true;
  };
}
