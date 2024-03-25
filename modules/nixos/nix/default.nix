{ lib, options, config, pkgs, ... }:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.nix;
  light = config.cogisys.light;
in
  {
    options.cogisys.nix = with types; {
      enable = mkBoolOpt false "Enable nix management.";
    };

    config = mkIf cfg.enable {
      nix = {
        settings = {
          experimental-features = [ "nix-command" "flakes" ];
          http-connections = 50;
          warn-dirty = false;
          auto-optimise-store = true;

          substituters = [
            "https://nix-community.cachix.org"
          ];

          trusted-public-keys = [
             "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];

        };

        gc = {
          automatic = true;
          dates = "weekly";

          options = if light.memory
            then"-d"
            else "--delete-older-than 30d";
        };

        # Channels are evil! Use `nixpkgs` from flake inputs
        channel.enable = false;
        nixPath = [
          "nixpkgs=${pkgs.path}"
        ];
        settings.nix-path = config.nix.nixPath;

      };

      services.lorri.enable = true;
      programs.direnv.enable = true;

      environment.systemPackages = with pkgs; [
        snowfallorg.flake
        nixbang
        nix-melt
        vulnix
        nix-output-monitor
      ];

      documentation.nixos.enable = false;
      environment.variables.NIXPKGS_ALLOW_UNFREE = "1";

      system.activationScripts.diff = {
        supportsDryActivation = true;
        text = ''
        ${pkgs.nvd}/bin/nvd --nix-bin-dir=${pkgs.nix}/bin diff \
        /run/current-system "$systemConfig"
        '';
      };
    };
  }
