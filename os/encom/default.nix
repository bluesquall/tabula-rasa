{ config, lib, pkgs, modulesPath, ... }:

let
  USERNAME = "flynn";
  HOSTNAME = "encom";
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../filesystems.nix
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    # age.keyFile = "/var/lib/sops-nix/keys.txt";
    # ^ this needs to be on the root volume, not another subvolume
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    # ^ this would be if the secret was encoded to the host ssh key
    # ^ and it looks like sops-nix always checks for it there anyway
    # secrets.hashedPassword.neededForUsers = true;
    # ^ this is in user/flynn/default.nix, but could be here instead
  };

  hardware = {
    # enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
    };
    video.hidpi.enable = lib.mkDefault true;
  };

  boot = {
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "btrfs" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = HOSTNAME;
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
