{ ... }:

{
  disk = {
    main = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "64M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };
  };
  zpool = {
    zroot = {
      type = "zpool";
      options = {
        autotrim = "on";
        ashift = "12";
      };
      rootFsOptions = {
        acltype = "posixacl";
        canmount = "off";
        checksum = "edonr";
        mountpoint = "none";
        compression = "zstd";
        normalization = "formD";
        relatime = "on";
        xattr = "sa";
        dnodesize = "auto";
        "com.sun:auto-snapshot" = "false";
      };
      postCreateHook = ''
      zfs snapshot rpool@empty
      '';

      datasets = {
        reserved = {
          type = "zfs_fs";
          options = {
            canmount = "off";
            mountpoint = "none";
            reservation = "5GiB";
          };
        };
        root = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/";
        };
        home = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/home";
          options."com.sun:auto-snapshot" = "true";
        };
        nix = {
          type = "zfs_fs";
          options.mountpoint = "legacy";
          mountpoint = "/nix";
          options."com.sun:auto-snapshot" = "true";
        };
      };
    };
  };
}
