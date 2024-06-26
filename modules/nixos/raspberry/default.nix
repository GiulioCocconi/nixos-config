# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{ lib, inputs, options, config, pkgs, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.raspberry;
in
  {
    options.cogisys.raspberry = with types; {
      enable = mkBoolOpt false "Is the system a raspberry?";
      model = mkOpt (enum [0 1 2 3 4]) 4 "Raspberry model.";
    };

   config = mkIf cfg.enable {
     boot = {
       loader.grub.enable = mkDefault false;
       loader.generic-extlinux-compatible.enable = mkDefault true;
       loader.systemd-boot.enable = mkForce false;
       initrd.availableKernelModules = [ "usbhid" "usb_storage" "vc4" "pcie_brcmstb" "reset-raspberrypi" ];
     };

     hardware.enableRedistributableFirmware = true;

     environment.systemPackages = [
       pkgs.libraspberrypi
       pkgs.python311Packages.gpiozero
     ] ++ optionals (cfg.model > 3) [
       pkgs.cogisys.nix-rpi-eeprom-update
     ];

     services.xserver.videoDrivers = [ "fbdev" ];

   };
 }
