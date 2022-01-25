# tabula-rasa

a flaky example of NixOS configuration with full-disk encryption, home-manager, & secrets

## getting started

0. get a [NixOS] live system, e.g., from the [NixOS download page], or by
   building the ISO image from this repo's `flake.nix`:

   `nix build .#nixosConfigurations.iso.config.system.build.isoImage --impure`

   or

   `nix build github:bluesquall/tabula-rasa/ragenix#nixosConfigurations.iso.config.system.build.isoImage` --impure

1. boot into the [NixOS] live system

   - connect to your WiFi network:

     `nmcli device wifi connect <SSID> --ask`

2. partition and format your disks (see [preinstall])

3. install NixOS directly from the remote:

      `nixos-install --flake github:bluesquall/tabula-rasa/agenix#encom`

   or by cloning this repo, modifying accordingly, and installing from the
   local clone:

      `nixos-install --flake .#encom`

4. reboot


## details

### full-disk encryption (and darling erasure)

- [mt-caret]

- [eyd]

### home-manager

- [hm-flakes]

This example provides a home-manager configuration in `flake.nix` so that
you can install it on a non-NixOS sytstem (e.g., Ubuntu with nix & flakes).

### secrets

  - [x] implement a simple secure example using out-of-band storage

  - [x] provide an example using `agenix`

    - [x] and a derivative example using `ragenix`

  - [x] provide an example using `nix-sops`

### shell

The login shell is `zsh` so that anything expecting POSIX compliance will
get it, but the keyboard shortcut for the terminal uses `fish` so that's
what you will get for most interactive shells on the machine.

Here's the relevant line in `~/.config/i3/config`:

```
bindsym $mod+Return exec "SHELL=`which fish` uxterm"
```

Kudos to Matt Hart for [suggesting this approach in a post][fish-n-nix]. I
haven't needed `fenv` yet, but that may a difference between using NixOS and
using `nix` on top of a different OS.

### terminal emulators

To keep the this example derivation minimal, we rely on `uxterm` with a few
customizations in `~/.Xresources` to keep it from blinding you with the
default white background.

### editor

This example includes neovim.

### password manager

Use one! `pass` works for me, `passage` may be better.


_____________

[NixOS]: https://nixos.org
[NixOS download page]: https://nixos.org/download.html
[mt-caret]: https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
[eyd]: https://grahamc.com/blog/erase-your-darlings
[fish-n-nix]: https://mjhart.netlify.app/posts/2020-03-14-nix-and-fish.html
[hm-flakes]: https://dee.underscore.world/blog/home-manager-flakes/
