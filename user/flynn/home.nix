{ pkgs, ... }:

let
  USERNAME = "flynn";
in
{
  programs.home-manager.enable = true;
  fonts.fontconfig.enable = true;
  home = {
    username = "${USERNAME}";
    homeDirectory = "/home/${USERNAME}";
    stateVersion = "24.11";

    sessionVariables = {
      PAGER = "less";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    packages = with pkgs; [
      dejavu_fonts
      (nerdfonts.override { fonts = [ "Mononoki" ]; })
      less
      tree
    ];

    file = {

      "i3.config" = {
        target = ".config/i3/config";
        text = ''
set $mod Mod4
font pango:monospace 8
bindsym $mod+Return exec "SHELL=`which fish` uxterm"
bindsym $mod+Shift+q kill
bindsym $mod+d exec dmenu_run
bindsym $mod+h split h
bindsym $mod+v split v
bindsym $mod+f fullscreen toggle
bindsym $mod+Shift+r restart
bindsym $mod+Shift+c reload
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"
set $ws1 "1"
set $ws2 "2"
bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bar {
        status_command i3status
}
exec xinput set-prop (xinput list --name-only | grep Touchpad) 'libinput Tapping Enabled' 1
        '';
      };

      ".Xresources" = {
        target = ".Xresources";
        text = ''
UXTerm*foreground: orange
UXTerm*background: black
UXTerm*renderFont: true
UXTerm*faceName: Mononoki Nerd Font
UXTerm*faceSize: 8

XTerm*selectToClipboard: true
Ctrl Shift <Key>C: copy-selection(CLIPBOARD)
Ctrl Shift <Key>V: insert-selection(CLIPBOARD)
        '';
      };
    };
  };

  programs = {

    fish = {
      enable = true;
      interactiveShellInit = ''
set fish_greeting # get rid of the greeting
      '';
    };

    gpg.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    };

    tmux.enable = true;
  };

  services = {
    gpg-agent.enable = true;
  };

}
