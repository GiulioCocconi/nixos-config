# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT
{ config, lib, pkgs, inputs, modulesPath, ... }:

with lib;
with lib.cogisys;

{
  imports = with inputs.nixos-hardware.nixosModules; [
    (modulesPath + "/installer/scan/not-detected.nix")
    common-cpu-amd-pstate
    common-gpu-amd
    common-pc-laptop
    common-pc-laptop-acpi_call
    common-pc-laptop-ssd
];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];

  boot.kernelParams = [
    "acpi_backlight=native"
    "psmouse.synaptics_intertouch=0"
  ];

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };


  environment.systemPackages = with pkgs; [ acpi thinkfan ];

  swapDevices = [ ];

  # FIX: MIC LED should always be off
  systemd.services.mic-led-fix = writeFileService {
    file = "/sys/class/sound/ctl-led/mic/mode";
    text = "off";
  };

  # FIX: The default audio card should be the one controlling the computer speakers,
  #      not HDMI
  environment.variables.AUDIODEV = "hw:1,0";

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
