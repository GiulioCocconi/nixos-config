# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT
{ config, lib, pkgs, inputs, modulesPath, disko, ... }:

with lib;
with lib.cogisys;

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];


  disko.devices = import ./disko-config.nix {};

  boot.initrd.availableKernelModules = [ "xhci_pci" "usb_storage" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
