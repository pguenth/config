Readme for the files that are mangaed my yamd

The configuration of the following tools is managed:
 * vim
 * ranger
 * xonsh
 * xmonad
 * xmobar
 * vnc

Additionally, ssh pubkeys for all my machines are stored in .ssh/authorized_keys_def. Activate this file by adding it to the option AuthorizedKeysFile /etc/ssh/sshd_config .

There are keymap-cheatsheets that can be found in cheatsheets/ for ranger and xmonad.

So far this should be in principle transferrable to every distribution. The packages that form the base of my Arch Linux setup can be found in the files named package-list-*:
 * -native: Native packages, split into
    * -essential: packages I consider essential for daily use
    * -essential-groups: Native packages, where all packages from big package groups have been replaced by their group name (for convienience when reading)
    * -nonessential: potentially large packages (or packages requiring large dependencies) which can be considered depending on the use case of the installation
 * -foreign: AUR and other packages
