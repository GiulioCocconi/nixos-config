# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, options, config, pkgs, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.tools.gnupg;
  networking = config.cogisys.system.networking;
  gui = config.cogisys.system.gui;
in
{
	options.cogisys.tools.gnupg = with types; {
		enable = mkEnableOption "gnupg";
	};

	config = mkIf cfg.enable {
		assertions = [
			(mkAssertionModule networking "networking" "opengp")
		];

		programs.gnupg.agent = {
			enable = true;
		};

		environment.systemPackages = optional gui.enable pkgs.gpa;
	};
}
