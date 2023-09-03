{ lib, config, options, ...}:
with lib;

let
  cfg = config.cogisys.virtualmachine;
in
{
  options.cogisys.virtualmachine = with types; {
    enable = mkBoolOpt false "Is the system a virtualmachine?";
    software = mkOpt (enum ["virtualbox" "vmware"]) "virtualbox" "Software used for virtualization.";
  };

  imports = optionals cfg.enable [(modulesPath + "/profiles/minimal.nix")];

  config = mkIf cfg.enable {
      cogisys = {
        light = enabled;
        system = {
          printing.enable = mkForce false;
          networking.wifi.enable = mkForce false;
          boot.mode = "legacy";
        };
      };

      virtualisation.${cfg.software}.guest.enable = true;

    };
}
