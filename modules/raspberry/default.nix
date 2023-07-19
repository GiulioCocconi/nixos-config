{ lib, inputs, options, config, pkgs, ...}:
with lib;

let
  cfg = config.cogisys.raspberry;
in
  {
    options.cogisys.raspberry = with types; {
      enable = mkBoolOpt false "Is the system a raspberry?";
      model = mkOpt (enum [0 1 2 3 4]) 4 "Raspberry model.";
      overclock = mkBoolOpt false "Overclock the system?";
    };

    config = mkIf cfg.enable {

      assertions = [{
        assertion = cfg.overclock -> (cfg.model >= 3);
        message = "Only Raspberry Pi >= 3 supports overclocking";
      }];

      boot = {

        loader.grub.enable = mkDefault false;

        loader.raspberryPi = {
          enable = true;
          version = cfg.model;

        # Parameters to be added to /boot/config.txt
        # https://www.raspberrypi.com/documentation/computers/config_txt.html
        firmwareConfig = with inputs.nixpkgs.lib; concatLines [
          (optionalString cfg.overclock "arm_boost=1")
          (optionalString (cfg.overclock && cfg.model > 3) "gpu_freq=750")
          (optionalString (cfg.overclock && cfg.model > 3) "over_voltage=6")
        ];
      };

      initrd.availableKernelModules = [
        "usbhid" "usb_storage" "vc4" "pcie_brcmstb" "reset-raspberrypi"
      ];

      # TODO: Change based on the model
      kernelPackages = mkDefault pkgs.linuxPackages_rpi4;
    };

    hardware.enableRedistributableFirmware = true;

    environment.systemPackages = [
      pkgs.libraspberrypi
      pkgs.python311Packages.gpiozero
    ] ++ optionals (cfg.model > 3) [
      pkgs.raspberrypi-eeprom
    ];

  };
}
