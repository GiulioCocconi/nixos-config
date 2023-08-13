{lib, config, ...}:


with lib;
let
  cfg = config.cogisys.system.boot;
in
{
  options.cogisys.system.boot = with types; {
    enable = mkEnableOption "booting.";
    dualBoot = mkBoolOpt false "Is the system dual-booting?";
    rootFilesystem = mkOpt (enum ["ext4" "zfs" "btrfs"]) "ext4" "Filesystem of root";
    mode = mkOpt (enum ["legacy" "UEFI"]) "UEFI" "Boot Mode";
    device = mkOpt types.str "nodev" "Where to install the bootloader";
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.mode == "legacy") -> (cfg.device != "nodev");
        message = "If you're booting in legacy mode you should specify a boot device!";
      }
      {
        assertion = (cfg.mode == "UEFI") -> (cfg.device == "nodev");
        message = "If you're booting in UEFI mode you should use \"nodev\" as boot device!";
      }
    ];
    boot = {
      loader = {
        grub.enable = (cfg.mode == "legacy");
        systemd-boot.enable = (cfg.mode == "UEFI");
        grub.device = cfg.device;
        grub.useOSProber = cfg.dualBoot;
      };
      supportedFilesystems = [ cfg.rootFilesystem ];
    };
  };
}
