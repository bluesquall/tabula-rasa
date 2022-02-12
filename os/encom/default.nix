{ config, lib, pkgs, modulesPath, ... }:

let
  USERNAME = "flynn";
  HOSTNAME = "encom";
in
{
  imports = [
    ../filesystems.nix
  ];

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
        bits = 4096;
      }
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  hardware = {
    # enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = lib.mkDefault true;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };
    video.hidpi.enable = lib.mkDefault true;
  };

  boot = {
    kernelModules = [ "kvm-intel" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = HOSTNAME;
    hostId = "DEADBEEF";
    useDHCP = false;
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "US/Pacific";

  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    xserver = {
      enable = true;
      dpi = 180;
      layout = "us";
      libinput.enable = true;
      videoDrivers = [ "vesa" "modesetting" ];
      # ^these are tried in order until finding one that supports the GPU.
      displayManager = {
        sddm.enable = true;
        defaultSession = "none+i3";
      };
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [ dmenu i3status ];
      };
    };
  };

  environment.systemPackages = with pkgs; [ bash curl git xterm zsh ];

  users = {
    mutableUsers = false;
    users.root.hashedPassword= "!"; # < disable password login for root
  };

  system.stateVersion = "22.05";
}
