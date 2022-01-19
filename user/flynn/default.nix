{ pkgs, ... }:

let
  USERNAME = "flynn";
  UID = 4983;
in
{
  users.users.${USERNAME} = {
    uid = UID;
    home = "/home/${USERNAME}";
    createHome = true;
    isNormalUser = true;
    extraGroups = [ "dialout" "networkmanager" "wheel" ];
    shell = pkgs.zsh; # keep a POSIX login shell
    passwordFile = "/home/.keys/passwd.sha512crypt";
  };

  home-manager.users.${USERNAME} = import ./home.nix;

  services.xserver.displayManager.autoLogin = {
    enable = true;
    user = USERNAME;
  };
}
