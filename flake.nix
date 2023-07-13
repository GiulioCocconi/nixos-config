{
  description = "CoGi Systems ";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
	unstable.url = "github:nixos/nixpkgs/nixos-unstable";
	nixos-hardware.url = "github:nixos/nixos-hardware";
	nur.url = "github:nix-community/NUR";

	## TODO! Enable when supported by snowfall lib
    # home-manager = {
	  # url = "github:nix-community/home-manager/relase-23.05";
	  # inputs.nixpkgs.follows = "nixpkgs";
	# };

	comma = {
	  url = "github:nix-community/comma";
	  inputs.nixpkgs.follows = "unstable";
	};

	flake-checker = {
	  url = "github:DeterminateSystems/flake-checker";
	  inputs.nixpkgs.follows = "unstable";
	};

	deploy-rs = {
      url = "github:serokell/deploy-rs";
	  inputs.nixpkgs.follows = "unstable";
	};

	snowfall-lib = {
      url = "github:snowfallorg/lib";
	  inputs.nixpkgs.follows = "nixpkgs";
	};

	snowfall-flake = {
      url = "github:snowfallorg/flake";
	  inputs.nixpkgs.follows = "unstable";
	};
  };

  outputs = inputs:
    let
	  lib = inputs.snowfall-lib.mkLib {
	     inherit inputs;
		 src = ./.;

	  };
	in lib.mkFlake {
	  package-namespace = "cogisys";
	  channels-config = { allowUnfree = true; };

      systems.modules = with inputs; [
	    nur.nixosModules.nur
	  ];

	  # checks = builtins.mapAttrs
		# (system: deploy-lib:
			# deploy-lib.deployChecks
			# inputs.self.deploy)
		# inputs.deploy-rs.lib;


	};
}
