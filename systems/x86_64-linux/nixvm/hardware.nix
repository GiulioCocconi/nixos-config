{ config, lib, pkgs, modulesPath, ... }:
with lib;

{

  boot.loader.grub.device = mkForce "/dev/sda";

  boot.initrd.availableKernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/76c63e53-6536-4d21-b811-d76a812dbb95";
      fsType = "ext4";
    };

  swapDevices = [ ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
