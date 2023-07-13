{ lib, config, options, pkgs, ... }:
with lib;

let
  cfg = config.cogisys.system.gui;
  locale = config.cogisys.system.locale;
in
{
  options.cogisys.system.gui = with types; {
    enable = mkBoolOpt false "Enable gui.";
  };

  config = mkIf cfg.enable {

    services.xserver = {
	  enable = true;
	  layout = locale.keyboardLayout;
    };

	fonts.fonts = with pkgs; [
	  google-fonts
	  noto-fonts
	  (nerdfonts.override { fonts = [ "Iosevka" ]; })
	];

	environment.systemPackages = with pkgs; [
      st
	  mpv
	  zathura
	  libreoffice-fresh
	  chromium
	  flameshot
	];

	environment.shellAliases.open = "xdg-open";

  };
}
