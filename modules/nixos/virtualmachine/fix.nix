{ lib, config, options, ...}:
with lib;
with lib.cogisys;

let
  cfg = config.cogisys.virtualmachine;
  gui = config.cogisys.system.gui;

  mkVBClientService = desc: flags: {
    description = "VirtualBox Guest: ${desc}";

    enable = true;
    wantedBy = [ "graphical-session.target" ];
    requires = [ "dev-vboxguest.device" ];
    after = [ "dev-vboxguest.device" ];

    serviceConfig.ExecStart =
      "${config.boot.kernelPackages.virtualboxGuestAdditions}/bin/VBoxClient -fv ${flags}";
    };

in
{

  options.cogisys.virtualmachine = with types; {
    enable = mkBoolOpt false "Is the system a virtualmachine?";
    software = mkOpt (enum ["virtualbox" "vmware"]) "virtualbox" "Software used for virtualization.";
  };

  config = mkMerge [

    (mkIf cfg.enable {
      cogisys = {
        # suites.light = enabled;
        system = {
          printing.enable = mkForce false;
          networking.wifi.enable = mkForce false;
        };
      };
    })

    (mkIf (cfg.enable && (cfg.software == "virtualbox")) {
      systemd.services.vb-clipboard = mkVBClientService "Clipboard" "--clipboard";
      virtualisation.virtualbox.guest.enable = true;
    })

    (mkIf (cfg.enable && gui.enable && (cfg.software == "virtualbox")) {
      systemd.services.vb-resolution = mkVBClientService "Resolution auto-resize" "--vmsvga";
    })

    (mkIf (cfg.enable && (cfg.software == "vmware")) {
      virtualisation.vmware.guest.enable = true;
    })
  ];
}
