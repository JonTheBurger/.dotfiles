# Hyprland

This document describes the layers of my preferred Hyprland system.
Alternatives are listed as well.

## cachyos

CachyOS is an Arch Linux based distribution that provides bleeding edge
software with CPU-specific optimizations enabled. The theoretical trade-off is
less system stability (though I've found stability to be good).

> See also: nixos, fedora, ubuntu

## btrfs

Btrfs (B-tree filesystem, sometimes pronounced "butter FS") is a modern
copy-on-write (COW) filesystem with excellent snapshot support. By pairing it
with `snap-pac`, every `pacman` package install creates snapshots
automatically, thereby enabling easy rollback if an update breaks your system.

> See also: zfs, ext4

## limine

limine is a modern bootloader, and replaces `grub` in this stack. It provides
easy support for btrfs snapshots. At time of writing, grub's only advantage
seems to be booting into fully encrypted disks - something I personally do not
have a use for.

I personally prefer to see the kernel messages over a splash screen, so I
remove `quiet splash` and add `loglevel=3` to `KERNEL_CMDLINE[default]`.
`limine-entry-tool` and `limine-snapper-sync` allow you to configure your
kernel boot command line for these snapshots from a template:

```bash
# Edit
sudo vim /etc/default/limine
# Apply
sudo limine-mkinitcpio
```

> See also: grub

## tuigreet

tuigreet is a bare-bones, text-based display manager used for logging in. I
prefer a fast login over a pretty login. `greetd` will drop you back to the
login screen if your desktop or compositor crash.

```toml
# Tweak /etc/greetd/config.toml to not use the same tty as kernel logs
[terminal]
vt = "next"
```

> See also: ly, light-dm, plasma-login-manager

## uwsm

The Universal Wayland Session Manager handles startup through systemd, the most
commonly used Linux initialization system and service manager. It also
integrates better with XDG (Cross-Desktop Group) standards. This is optional,
but helped me fix lagging startup and browsers "terminating unexpectedly" upon
shutdown.

Configure environment variables in `~/.config/uwsm/env`. Use `systemd-analyze
blame` and `systemd-analyze --user blame` to analyze long startup issues.

## Wayland

Wayland is **the** modern display protocol on Linux, replacing X11.

> See also: X11

## Hyprland

Hyprland is a dynamic tiling Wayland compositor. It arranges windows in a grid
automatically, is Lua configurable, and has a lot of colorful animations!

> See also: niri, kde-plasma

## Noctalia

Noctalia is a shell built on `quickshell`, written in QML and C++. It provides
a taskbar and widgets, along with a unified theming system. It is fairly
lightweight and complete. Dank Material Shell is another neat option, but is
slightly heavier and more infectious (integrated with?) to your Hyprland
config.

> See also: dms (Dank Material Shell)

## TODO

- disable hyprland wallpaper
- lua cleanup
- window overview
- alt tab
- WIN+SHIFT+A/D
- Caps+Alt workspaces
