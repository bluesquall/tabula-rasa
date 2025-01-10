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
curl --output-dir /tmp -#SLO https://raw.githubusercontent.com/bluesquall/tabula-rasa/main/INSECURITIES/ssh_host_ed25519_key
```

### 3. download and run `mknix`

**This script will overwrite everything on the disk you direct it to.**

The script will prompt you for a LUKS passphrase. This encrypts everything on
your disk, except for the EFI partition.

```shell
curl -#SLO https://raw.githubusercontent.com/bluesquall/tabula-rasa/main/mknix
sudo sh ./mknix /dev/nvme0n1
```

### 4. reboot

Your username is `flynn` and your password is `sam`.

Now you have a working NixOS installation on an encrypted drive. Remember that
your `sops-nix`	secrets are **INSECURE** because the secret keys are posted
publicly. Proceed to the next section to re-key and change the secrets.

## adapting to your own needs

To adapt this repository to use your own user and host names, and to use
secure host keys, you will need to install from a local clone (and *NOT*
directly from the remote). You can do this all from the live system. I
recommend generating the host (and user) keypair before connecting to the
internet:

- [ ] generate your own host keys:

      `ssh-keygen -t ed25519 -f /tmp/ssh_host_ed25519_key -C "root@encom"`

      or copy them from secured bootstrap storage, e.g.:

      ```shell
      $ sudo su
      # cryptsetup open /dev/disk/by-partlabel/BOOTSTRAP bootstrap
      # mount /dev/mapper/bootstrap /mnt
      # cp /mnt/keys/host/encom/ssh_host_ed25519_key /tmp
      # umount /mnt
      # cryptsetup close bootstrap
      # exit
      $ echo "please physically remove your bootstrap storage now"
      ```

- [ ] clone the repo:
      `git clone https://github.com/bluesquall/tabula-rasa /tmp/tabula-rasa`

- [ ] configure `secrets.nix` to use the new host key:

      ```shell
      pushd /tmp/tabula-rasa
      pushd user/flynn/secrets
      nvim secrets.nix
      # then, `:r! cat /tmp/ssh_host_ed25519_key.pub`
      # and move the output in between the " on line 4
      # finally, close with `:q`
      ```

- [ ] overwrite `hashedPassword.age` with a new password[^1]:

      ```shell
      rm hashedPassword.age # remove the old one
      nix run github:ryantm/agenix -- -e hashedPassword.age -i /tmp/ssh_host_ed25519_key
      # then, `:r! mkpasswd -msha512crypt sam`
      # and make sure it is the only line in the file
      # then remove the password from the vim history: `:call histdel(":", "mkpasswd")`
      # and write out viminfo: `:wviminfo!`
      # finally, close with `:wq`
      ```

      If you are working from one of the official ISO images, you may
      encounter an error:

      > `error: experimental Nix feature ‘nix-command’ is disabled; use ‘--extra-experimental-features nix-command’ to override`

      so you would replace:

      `nix run github:ryantm/agenix -- -e hashedPassword.age -i /tmp/ssh_host_ed25519_key`

      with:

      `nix --extra-experimental-features nix-command --extra-experimental-features flakes run github:ryantm/agenix -- -e hashedPassword.age -i /tmp/ssh_host_ed25519_key`

- [ ] run the script to partition, format, encrypt, and mount your disks,
      and then install NixOS:

      `sh ./mknix /dev/nvme0n1`

- [ ] reboot


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
