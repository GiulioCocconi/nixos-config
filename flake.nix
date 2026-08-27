# Copyright (c) 2026 Giulio Cocconi
# SPDX-License-Identifier: MIT

{
  description = "CoGi Systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";


    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-config = {
      url = "github:GiulioCocconi/cemacs";
      flake = false;
    };

    somewm = {
      url = "github:trip-zip/somewm/release/1.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    awesome-config = {
      url = "github:GiulioCocconi/awesomewm";
      flake = false;
    };

    rippkgs = {
      url = "github:replit/rippkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flakelight.url = "github:nix-community/flakelight";
  };

  outputs = { flakelight, ... } @ inputs:
    flakelight ./. {
      inherit inputs;

      nixpkgs.config.allowUnfree = true;

      # Custom CoGi Systems helper library, exposed as a normal flake `lib`
      # output instead of being injected into the Nixpkgs `lib` namespace.
      lib = { lib, ... }: {
        cogisys = (import ./lib/module { inherit lib; })
          // (import ./lib/utils { inherit lib; })
          // (import ./lib/user { inherit lib; });
      };

      # Aggregated reusable NixOS module, exposed as a normal flake module.
      nixosModules.cogisys = ./modules/nixos;
    };
}
