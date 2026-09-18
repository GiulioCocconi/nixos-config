# Copyright (c) 2026 Giulio Cocconi
# SPDX-License-Identifier: MIT

# Local Nixpkgs overlays, exposed as normal flake `overlays` outputs and used
# as the single source of truth for the overlays applied to the package set
# (see `nix/withOverlays.nix`).

{ inputs, ... }:

{
  awesome = import ../overlays/awesome;
  chromium = import ../overlays/chromium;
  dyalog = import ../overlays/dyalog;
  mathematica = import ../overlays/mathematica;
  prismlauncher-unwrapped = import ../overlays/prismlauncher-unwrapped;
  st = import ../overlays/st;
  somewm = import ../overlays/somewm { inherit inputs; };
}
