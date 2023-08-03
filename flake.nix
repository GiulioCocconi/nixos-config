{
  description = "CoGi Systems ";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    # nur.url = "github:nix-community/NUR";


    flake-checker = {
      url = "github:DeterminateSystems/flake-checker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Used to get awesomwm using luajit
    nixpkgs-f2k = {
      url = "github:fortuneteller2k/nixpkgs-f2k";
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

  };

  outputs = inputs:
  let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

    };
  in lib.mkFlake {
    overlay-package-namespace = "cogisys";
    channels-config = { allowUnfree = true; };

    systems.modules = with inputs; [
        # nur.nixosModules.nur
        # home-manager.nixosModules.home-manager {
          # useUserPackages = true;
        # }
      ];

      # checks = builtins.mapAttrs
        # (system: deploy-lib:
            # deploy-lib.deployChecks
            # inputs.self.deploy)
        # inputs.deploy-rs.lib;


      };
    }
