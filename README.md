Readme for the files that are managed by [yadm](https://yadm.io/)
=================================================================

This is the repository managing my configuration files for most applications I use on my typical Linux setup. Please don't consider the contents of this repository to be particularly well-thought or clean. Many things are evolved over time by compiling ideas or applying fixes found around the internet.

The configuration of the following tools is managed
---------------------------------------------------
 * vim
 * ranger
 * xonsh
 * xmonad
 * xmobar
 * vnc
 * zathura

Additional contents
-------------------
 * Additionally, ssh pubkeys for all my machines are stored in `.ssh/authorized_keys_def`. Activate this file by adding it to the option `AuthorizedKeysFile` in `/etc/ssh/sshd_config`.
 * There are keymap-cheatsheets that can be found in `cheatsheets/` for ranger and xmonad.
 * Package lists I find my base system to consist of if Arch Linux is the distribution of choice can be found in the files named `package-list/package-list-*`
     * `-native`: Official repository packages, split into
        * `-essential`: packages I consider essential for daily use
        * `-essential-groups`: Native packages, where all packages from big package groups have been replaced by their group name (for convienience when reading)
        * `-nonessential`: potentially large packages (or packages requiring large dependencies) which can be considered depending on the use case of the installation
     * `-foreign`: AUR and other packages

Things that need to be configured otherwise (to be extended)
------------------------------------------------------------
 * `vpnc` /etc/vpnc/home.conf is not tracked by this repository
 * plocate-updatedb.timer has to be enabled and optionally the timeout may be shortened. Its configuration `/etc/updatedb.conf` is not tracked by this repository.

Features/details of the ranger setup used
-----------------------------------------
* **search with `plocate`/`fzf`:**
There are custom commands defined for calling ~~mlocate/~~ plocate and fzf, where files are queried with plocate and are filtered with fzf. See the [cheatsheet](cheatsheets/ranger/ranger-haug.pdf) for details.
The locate config in /etc/updatedb.conf is modified to include `/mnt` and the timer `plocate-updatedb.timer` is modified with systemctl edit to run every ten minutes.
~~The updatedb-service is modified with systemctl edit to also update the plocate database.~~ If I am not missing something `plocate` is managed independently from `mlocate` now (Arch Linux packages its own timer and service).

* **recent files with `fasd`:**
Recent files/directories are stored on every directory change or file opening action in ranger with fasd (see `plugin/plugin_fasd_log.py`). I barely use this feature so this is not maintained in any way.

    * There is a command :fasd to query the directories and open the best match.
    * Sources on this topic: [here](https://github.com/ranger/ranger/wiki/Integration-with-other-programs#fasd), [here](https://github.com/ranger/ranger/wiki/Custom-Commands#visit-frequently-used-directories)

* **archives browsing with `avfs`:**
Commands are set up for seamless browsing of archives with `avfs` (see `avfs_*` in `commands.py`). The key binding for opening files or directories is modified to recognize archive suffixes and automatically mount them using `avfs` when using those commands.
