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
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
      (google-fonts.override { fonts = [ "CormorantGaramond" ]; })
    ];

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "cemacs"
        ''
            EMACS_CMD="${myEmacs}/bin/emacs --init-directory ${emacsDir} $@"

            # if there is a nix-shell environment in the project root directory
            # then load cemacs in it.

            # if you're editing a nix-shell file, ignore the environment, else
            # figure out what the root dir is and load cemacs.
            search_for_shell_file() {
                for path in "$@"; do
                    if [ -e $path ]; then
                        SHELL_FILE=$path
                        return
                    fi
                done
            }

            if [[ $1 == "" ]]; then
                search_for_shell_file "$(pwd)/shell.nix"\
                                      "$(pwd)/default.nix"

            elif [[ ! $1 =~ ^.*\/(default|shell).nix ]]; then
                # figure out the project root directory
                ELISP_CMD="(message (get-vc-root \"$1\"))"
                ROOT_PATH=$(emacs --batch --load ./emacs.d/early-init.el\
                            --eval "$ELISP_CMD" 2>&1 | tail -1)

                search_for_shell_file "$ROOT_PATH/shell.nix"\
                                      "$ROOT_PATH/default.nix"\
                                      "$(pwd)/shell.nix"\
                                      "$(pwd)/default.nix"
            fi

            if [[ $SHELL_FILE == "" ]]; then
                 EMACS_PURE=TRUE setsid $EMACS_CMD &
            else
                EMACS_PURE=TRUE nix-shell --run "setsid $EMACS_CMD &" $SHELL_FILE
            fi
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
