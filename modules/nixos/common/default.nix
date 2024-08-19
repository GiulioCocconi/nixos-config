# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, options, config, pkgs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.common;
in
  {
    options.cogisys.common = with types; {
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
        eza
        killall
        rclone
        zip
        xz
        unzip
        htop
        pciutils
        usbutils
        udiskie
        aria2
        xdg-user-dirs
      ];

      programs.nano.enable = mkDefault false;

      programs.neovim = {
        enable = true;
        defaultEditor = true;
      };

      hardware.bluetooth.enable = true;
      hardware.enableRedistributableFirmware = true;

      boot.kernelPackages = mkDefault pkgs.linuxPackages_zen;

      services.udisks2.enable = true;
      services.fwupd.enable = mkDefault true;
      
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
        ls = "eza";
        udm = "udisksctl mount -b";
      };

      environment.shellInit = ''
        mkcd() {
          mkdir -p $1
          cd $1
        }
      '';

      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };
      
      systemd.extraConfig = ''
        DefaultTimeoutStopSec=10s
      '';

    };
  }
