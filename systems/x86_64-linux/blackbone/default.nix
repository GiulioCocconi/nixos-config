# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ config, lib, pkgs, ... }:
with lib;
with lib.cogisys;

{

  imports = [ ./hardware.nix ];

  cogisys = {
    suites.scientificWriting = enabled;
    suites.development = enabled;

    system.networking.wifi = enabled;

    apps.emacs = enabled;
    apps.obs = enabled;
    
    system.gui = enabled;
    tools.gnupg = enabled;

  };

  users.users = mkUsers [{
    userName = "giulio";
    fullName = "G. Cocconi";
    isAdmin = true;
    packages = with pkgs; [  qucs-s ngspice mathematica jetbrains.clion ];
  }];

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  services.usbmuxd.enable = true;

  environment.systemPackages = with pkgs; [
    ifuse
    libimobiledevice
    rsync
  ];

  system.stateVersion = "23.05";

}
