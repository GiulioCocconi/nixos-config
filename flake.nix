{
  description = "CoGi Systems ";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
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

  };

  outputs = inputs:
  inputs.snowfall-lib.mkFlake {
    inherit inputs;
    src = ./.;
    snowfall.namespace = "cogisys";
    channels-config = { allowUnfree = true; };
    overlays = with inputs; [ snowfall-flake.overlays."package/flake" ];
    systems.modules = with inputs; [
      disko.nixosModules.disko
    ];
  };
}
