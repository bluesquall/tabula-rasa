#filesystems.nix

{ config, lib, pkgs, modulesPath, ... }:

{

  boot.kernelParams = [ "nohibernate" ];
  boot.initrd = {
    availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    postDeviceCommands = lib.mkAfter ''
      zfs rollback -r rpool/transient/root@strap
    '';
    supportedFilesystems = [ "zfs" ];
  };
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.enableUnstable = true;

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
