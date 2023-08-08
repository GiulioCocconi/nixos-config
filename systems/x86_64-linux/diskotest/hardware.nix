{ config, lib, pkgs, ... }:
with lib;
let
  disk_name = "/dev/sda";
in
{


  diskio.devices = {
    disk = {
      vdb = {
        device = disk_name;
        type = "disk";
        content = {
          type = "table";
          format = "gpt";
          partitions = [{
            name = "nixos";
            start = "1MiB";
            end = "100%";
            part-type = "primary";
            bootable = true;
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          }];
        };
      };
    };
  };

  boot.loader.grub.device = mkForce disk_name;

  boot.initrd.availableKernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  swapDevices = [ ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
