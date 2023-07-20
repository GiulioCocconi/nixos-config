{
  description = "CoGi Systems ";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    ##nixos-hardware.url = "github:nixos/nixos-hardware";
    # nur.url = "github:nix-community/NUR";
    nixos-hardware-pi.url = "github:nixos/nixos-hardware?rev=ca29e25c39b8e117d4d76a81f1e229824a9b3a26"

    # TODO! Wait until hm is supported in snowfall lib
    # home-manager = {
      # url = "github:nix-community/home-manager/release-23.05";
       # inputs.nixpkgs.follows = "nixpkgs";
     # };

     flake-checker = {
       url = "github:DeterminateSystems/flake-checker";
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
    package-namespace = "cogisys";
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
