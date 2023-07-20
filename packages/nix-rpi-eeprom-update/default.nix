{ lib,  pkgs, ... }:

pkgs.writeShellScriptBin "nix-rpi-eeprom-update" ''

  if [ "$(id -u)" != "0" ]; then
    echo "Please run as root!"
    exit 1
  fi

  mount /dev/disk/by-label/FIRMWARE /mnt
  BOOTFS=/mnt FIRMWARE_RELEASE_STATUS=stable ${pkgs.raspberrypi-eeprom}/bin/rpi-eeprom-update -d -a

''
