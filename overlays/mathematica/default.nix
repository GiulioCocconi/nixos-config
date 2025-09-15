# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{...}:
final: prev: {
  mathematica = prev.mathematica.override {
    source = prev.requireFile {
      name = "Mathematica.sh";
      #sha256 = "15ncsnwx8qbrpbvd3vmi19i0g57k8xx7i30idlak72b4pl244zi6"; #14.2
      sha256 = "18a8wf9j6n4dp631psa254hyniklm61i3qqrvvnz1sgfvd1hl6cf"; #14.3
      hashMode = "recursive";
      message = ''
      The installer is not present! To install matematica, first download the installer from
      https://wolfram.com/download-center/mathematica/.
      Then run "nix-store --query --hash \$(nix store add-path Mathematica_XX.X.X_BNDL_LINUX.sh --name 'Mathematica.sh')" in order to make it available and find the hash.

      '';
    };
  };
}
