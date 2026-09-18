# Copyright (c) 2026 Giulio Cocconi
# SPDX-License-Identifier: MIT

# Explicit NixOS host definitions. Each host receives the package set produced
# by the normal Nixpkgs overlay evaluation (Flakelight forwards `withOverlays`
# to every configuration) and the custom CoGi Systems library through
# `specialArgs`. No reconstructed `pkgs` is injected manually.

{ inputs, outputs, src, ... }:

let
  specialArgs = {
    cogisysLib = outputs.lib.cogisys;
  };

  mkHost = system: hostname: {
    system = system;
    specialArgs = specialArgs;
    modules = [
      inputs.disko.nixosModules.disko
      outputs.nixosModules.cogisys
      (src + "/systems/${system}/${hostname}")
      {
        networking.hostName = hostname;
        nixpkgs.hostPlatform = system;
      }
    ];
  };
in
{
  blackbone = mkHost "x86_64-linux" "blackbone";
  fangorn = mkHost "x86_64-linux" "fangorn";
  nixvm = mkHost "x86_64-linux" "nixvm";
  pandemonium = mkHost "x86_64-linux" "pandemonium";
  pamplemousse = mkHost "aarch64-linux" "pamplemousse";
}
