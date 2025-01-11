#filesystems.nix

{ config, lib, pkgs, modulesPath, ... }:

{
  boot = {
    kernelParams = [ "nohibernate" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" "vfat" "nls_cp437" "nls_iso8859-1" ];
      luks = {
        yubikeySupport = true;
        devices."ZED" = {
          device = "/dev/disk/by-partlabel/LUKS";

          yubikey = {
            slot = 2;
            twoFactor = false;
            gracePeriod = 30;
            keyLength = 64;
            saltLength = 16;

            storage = {
              device = "/dev/disk/by-partlabel/EFI";
              fsType = "vfat";
              path = "/salt-it";
            };
          };
        };
      };
      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r rpool/transient/root@strap
      '';
      supportedFilesystems = [ "zfs" ];
    };
    supportedFilesystems = [ "zfs" ];
  };

  fileSystems = {
    "/" = { 
      device = "rpool/transient/root";
      fsType = "zfs";
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/EFI";
      fsType = "vfat";
      neededForBoot = true;
    };
    "/home" = {
      device = "rpool/persistent/home";
      fsType = "zfs";
    };
    "/nix" = {
      device = "rpool/transient/nix";
      fsType = "zfs";
    };
  };

  swapDevices = [ ];
}
