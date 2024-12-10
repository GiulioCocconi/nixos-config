# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{config, options, lib, pkgs, inputs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.apps.emacs;

  # The ORG file in emacs-config input is the SSOT, the config
  # is generated from that file using `configDrv`

  configDrv = pkgs.stdenv.mkDerivation {
    name = "cemacs-config";
    src = inputs.emacs-config.outPath;
    buildInputs = [ pkgs.emacs ];
    buildPhase = "emacs --batch -l org config.org -f org-babel-tangle";
    installPhase = "cp -r emacs.d $out";
  };

  emacsDir = configDrv.outPath;

  myEmacs = pkgs.emacsWithPackagesFromUsePackage {
    config = "${emacsDir}/init.el";
    defaultInitFile = false;
    alwaysEnsure = true;
  };

in
{
  options.cogisys.apps.emacs = with types; {
    enable = mkEnableOption "emacs";
  };


  config = mkIf cfg.enable {

    fonts.packages = with pkgs; [
      nerd-fonts.iosevka
      (google-fonts.override { fonts = [ "CormorantGaramond" ]; })
    ];

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "cemacs"
        ''
            EMACS_PURE=TRUE setsid ${myEmacs}/bin/emacs --init-directory ${emacsDir} $@ &
        '')
      myEmacs # Required in order to load impure configs
    ];

    environment.variables = {

      # EMACS_PURE is not here since cemacs might be used in an impure configuration
      # in this system

      NIX_EMACS = "TRUE";
    };
  };
}
