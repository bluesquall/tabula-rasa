{ config, pkgs, ... }:

let
  USERNAME = "flynn";
  UID = 4983;
in
{

  sops.secrets.hashedPassword.neededForUsers = true;

  users.users.${USERNAME} = {
    uid = UID;
    home = "/home/${USERNAME}";
    createHome = true;
    isNormalUser = true;
    extraGroups = [ "dialout" "networkmanager" "wheel" ];
    shell = pkgs.zsh; # keep a POSIX login shell
    passwordFile = config.sops.secrets.hashedPassword.path;
  };

  home-manager.users.${USERNAME} = import ./home.nix;

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = USERNAME;
  };
}
