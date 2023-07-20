{ lib, inputs, options, config, pkgs, ...}:
with lib;

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

       initrd.availableKernelModules = [ "usbhid" "usb_storage" "vc4" "pcie_brcmstb" "reset-raspberrypi" ];
     };

     hardware.enableRedistributableFirmware = true;

     environment.systemPackages = with pkgs; [
       libraspberrypi
       python311Packages.gpiozero
     ] ++ optionals (cfg.model > 3) [
       raspberrypi-eeprom
       cogisys.nix-rpi-eeprom-update
     ];

     services.xserver.videoDrivers = [ "fbdev" ];

   };
 }
