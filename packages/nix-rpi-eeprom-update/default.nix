{ pkgs, ... }:

pkgs.writeShellScriptBin "nix-rpi-eeprom-update" ''
  mount /dev/disks/by-label/FIRMWARE /mnt
  BOOTFS=/mnt FIRMWARE_RELEASE_STATUS=stable ${pkgs.raspberrypi-eeprom}/bin/rpi-eeprom-update -d -a
''
