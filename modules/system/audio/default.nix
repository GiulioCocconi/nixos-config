{ lib, options, config, ... }:
with lib;

let
  cfg = config.cogisys.system.audio;
in
{
  options.cogisys.system.audio = with types; {
    enable = mkBoolOpt false "Enable audio";
  };

  config = mkIf cfg.enable {
    security.rtkit.enable = true;
	services.pipewire = {
      enable = true;
	  alsa.enable = true;
	  pulse.enable = true;
	  jack.enable = true;
	};
  };
}
