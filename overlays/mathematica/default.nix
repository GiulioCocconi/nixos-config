# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{...}:
final: prev: {
  mathematica = prev.mathematica.override {
    source = prev.requireFile {
      name = "Mathematica.sh";
      sha256 = "1zbcsrrb500izm9n3k91a811pgak406d1ja88xa8blcv18s6lsjc";
      hashMode = "recursive";
      message = ''
      The installer is not present! To install matematica, first download the installer from
      https://wolfram.com/download-center/mathematica/.
      Then run "nix-store --query --hash \$(nix store add-path Mathematica_XX.X.X_BNDL_LINUX.sh --name 'Mathematica.sh')" in order to make it available and find the hash.

      '';
    };
  };
}
