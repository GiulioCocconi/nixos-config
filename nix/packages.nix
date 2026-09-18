# Copyright (c) 2026 Giulio Cocconi
# SPDX-License-Identifier: MIT

# Local packages, exposed through Flakelight's default overlay so they are
# available to NixOS configurations as `pkgs.<name>`.

{ ... }:

{
  breezeCursor = { stdenvNoCC, fetchurl, hicolor-icon-theme }:
    stdenvNoCC.mkDerivation rec {
      name = "breezeCursor";
      version = "5.27.10";

      src = fetchurl {
        url = "mirror://kde/stable/plasma/${version}/breeze-${version}.tar.xz";
        sha256 = "18h08w3ylgvhgcs63ai8airh59yb4kc0bz2zi6lm77fsa83rdg5y";
      };

      dontDropIconThemeCache = true;

      propagatedBuildInputs = [
        hicolor-icon-theme
      ];

      installPhase = ''
        mkdir -p $out/share/icons/default
        cp -r cursors/Breeze/Breeze $out/share/icons
      '';
    };

  nix-rpi-eeprom-update = { writeShellScriptBin, raspberrypi-eeprom }:
    writeShellScriptBin "nix-rpi-eeprom-update" ''

      if [ "$(id -u)" != "0" ]; then
        echo "Please run as root!"
        exit 1
      fi

      mount /dev/disk/by-label/FIRMWARE /mnt
      BOOTFS=/mnt FIRMWARE_RELEASE_STATUS=stable ${raspberrypi-eeprom}/bin/rpi-eeprom-update -d -a

    '';
}
