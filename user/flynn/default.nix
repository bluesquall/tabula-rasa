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
    hashedPasswordFile = config.sops.secrets.hashedPassword.path;
  };

  home-manager.users.${USERNAME} = import ./home.nix;

  services.displayManager.autoLogin = {
    enable = true;
    user = USERNAME;
  };
}
