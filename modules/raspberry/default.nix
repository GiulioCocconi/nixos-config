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

    imports = with inputs.nixos-hardware-pi.nixosModules; [
      raspberry-pi-4
    ];

    config = mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.libraspberrypi
      pkgs.python311Packages.gpiozero
    ] ++ optionals (cfg.model > 3) [
      pkgs.raspberrypi-eeprom
    ];

  };
}
