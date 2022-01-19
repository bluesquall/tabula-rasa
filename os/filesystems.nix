#filesystems.nix

# { config, lib, pkgs, modulesPath, ... }:

{

  boot.initrd = {
    availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    luks.devices."crypt".device = "/dev/disk/by-partlabel/luks";
  };

  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-id/dm-name-crypt";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-partlabel/EFI";
      fsType = "vfat";
      neededForBoot = true;
    };
    "/home" = {
      device = "/dev/disk/by-id/dm-name-crypt";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };
    "/nix" = {
      device = "/dev/disk/by-id/dm-name-crypt";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };
    "/persist" = {
      device = "/dev/disk/by-id/dm-name-crypt";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
    };
    "/var/log" = {
      device = "/dev/disk/by-id/dm-name-crypt";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };
  };

  swapDevices = [ ];
}
