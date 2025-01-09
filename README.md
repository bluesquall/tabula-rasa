# tabula-rasa

a flaky example of NixOS configuration with full-disk encryption, home-manager, & secrets

## branches

I started this repository as a minimal working example to iron out issues
before applying the approach to my own system flake & dotfiles. Here is the
[discourse][discourse-bootstrap] where I posted my progress & questions.

Now I'm coming back with fresh eyes and I see the organization with the
different branches is probably confusing for people who just want to get
rolling, so I'm going to merge `ragenix` back into `main`. I'll leave the
`agenix` and `sops-nix` branches as alternate examples.

## INSECURE testing (quickstart)

The steps below will quickly get you to a bootable system, but use **INSECURE**
secret keys that are stored in the open in this repository.

**DO NOT USE THESE INSTRUCTIONS ON A PERMANENT SYSTEM** -- these insecure keys
are provided for demonstration only. Please skip ahead to getting started if
you want to make your own secure keys to use for anything other than
demonstration.

### 0. get a [NixOS] live system

e.g., from the [NixOS download page]

### 1. boot into the [NixOS] live system

### 2. get online and pull INSECURE keys

#### a. connect to your WiFi network:

`nmcli device wifi connect <SSID> --ask`
   
#### b. pull the INSECURE host private key into `/tmp`

```shell
curl --output-dir /tmp -#SLO https://raw.githubusercontent.com/bluesquall/tabula-rasa/sops-nix/INSECURITIES/ssh_host_ed25519_key
```

### 3. download and run `mknix`

**This script will overwrite everything on the disk you direct it to.**

The script will prompt you for a LUKS passphrase. This encrypts everything on
your disk, except for the EFI partition.

```shell
curl -#SLO https://raw.githubusercontent.com/bluesquall/tabula-rasa/sops-nix/mknix
sh ./mknix /dev/nvme0n1
```

### 4. reboot

Your username is `flynn` and your password is `sam`.

Now you have a working NixOS installation on an encrypted drive. Remember that
your `sops-nix`	secrets are **INSECURE** because the secret keys are posted
publicly. Proceed to the next section to re-key and change the secrets.

## getting started

0. get a [NixOS] live system, e.g., from the [NixOS download page], or by
   building the ISO image from this repo's `flake.nix`:

   `nix build .#nixosConfigurations.iso.config.system.build.isoImage`

   or

   `nix build github:bluesquall/tabula-rasa/sops-nix#nixosConfigurations.iso.config.system.build.isoImage`

1. boot into the [NixOS] live system

   - connect to your WiFi network:

     `nmcli device wifi connect <SSID> --ask`

2. partition and format your disks (see [preinstall])

3. install NixOS directly from the remote:

      `nixos-install --flake github:bluesquall/tabula-rasa/sops-nix#encom`

   or by cloning this repo, modifying accordingly, and installing from the
   local clone:

      `nixos-install --flake .#encom`

4. reboot


## details

### full-disk encryption (and darling erasure)

- [discourse-bootstrap]

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
[^1]: Obviously, use a more secure password than `sam`. And if you are
      adapting this repo on Ubuntu before you generate your own live disk,
      you may need to `apt install whois` to get `mkpasswd`.
_____________

[NixOS]: https://nixos.org
[NixOS download page]: https://nixos.org/download.html
[discourse-bootstrap]: https://discourse.nixos.org/t/bootstrap-fresh-install-using-agenix-for-secrets-management/
[mt-caret]: https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
[eyd]: https://grahamc.com/blog/erase-your-darlings
[fish-n-nix]: https://mjhart.netlify.app/posts/2020-03-14-nix-and-fish.html
[hm-flakes]: https://dee.underscore.world/blog/home-manager-flakes/
