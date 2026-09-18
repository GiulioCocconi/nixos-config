# Copyright (c) 2026 Giulio Cocconi
# SPDX-License-Identifier: MIT

# Overlays applied to the Nixpkgs instance during the fixpoint. These become
# part of `config.nixpkgs.overlays`, so Flakelight forwards them to every
# NixOS configuration via its propagation module. The local overlays are taken
# from the single source of truth in `nix/overlays.nix`.

{ inputs, config, ... }:

[
  inputs.rippkgs.overlays.default
  inputs.emacs-overlay.overlays.default
] ++ builtins.attrValues config.overlays
