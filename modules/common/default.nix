{ lib, options, config, pkgs, ...}:
with lib;

let
  cfg = config.cogisys.suites.common;
in
  {
    options.cogisys.suites.common = with types; {
      enable = mkBoolOpt true "Enable common configuration.";
    };

    config = mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        wget
        bat
        tree
        file
        fzf
        ripgrep
        exa
        killall
        rclone
        zip
        xz
        unzip
        htop
        pciutils
        usbutils
      ];

      programs.neovim = {
        enable = true;
        defaultEditor = true;
      };

      hardware.bluetooth.enable = true;
      hardware.enableRedistributableFirmware = true;
	  boot.kernelPackages = pkgs.linuxPackages_zen;

      cogisys = {
        nix = enabled;
        awesome = enabled;
        tools = {
          git = enabled;
          zsh = enabled;
          starship = enabled;
        };

        services = {
          openssh = enabled;
          tailscale = enabled;
        };

        system = {
          boot = enabled;
          locale = enabled;
          networking = enabled;
          printing = enabled;
          audio = enabled;
        };
      };

      environment.shellAliases = {
        cls = "clear";
        mkdir = "mkdir -p";
      };

      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      environment.shellInit = ''
      mkcd() {
        mkdir -p $1
        cd $1
      }
      '';

    };
  }
