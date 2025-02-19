# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{
  description = "CoGi Systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

     lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
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

    awesome-config = {
      url = "github:GiulioCocconi/awesomewm";
      flake = false;
    };

      # deploy-rs = {
      # url = "github:serokell/deploy-rs";
      # inputs.nixpkgs.follows = "unstable";
    # };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
	  inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.snowfall-lib.follows = "snowfall-lib";
    };

    rippkgs = {
      url = "github:replit/rippkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs:
  inputs.snowfall-lib.mkFlake {
    inherit inputs;
    src = ./.;
    snowfall.namespace = "cogisys";
    channels-config = { allowUnfree = true; };
    
    overlays = with inputs; [
      snowfall-flake.overlays."package/flake"
      rippkgs.overlays.default
      emacs-overlay.overlays.default
    ];
    
    systems.modules.nixos = with inputs; [
      disko.nixosModules.disko
      lix-module.nixosModules.default
    ];
  };
}
