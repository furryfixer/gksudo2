# gksudo2
## Gksudo Replacement, GUI open as Root, for X11 and Wayland, in Plasma, Gnome, XFCE.
### gksudo2 [-u | --user \<user\>] \<command\>
#### gksudo [-u | --user \<user\>] \<command\>
#### gksu [-u | --user \<user\>] \<command\>
#### REPLACES DEPRECATED gksudo/gksu as well as gksudo-pk. If looking for gksudo-pk, see notes at the end.
A drop-in replacement for **gksu** and **gksudo**, with fewer options. **WORKS FOR WAYLAND** as well as for X11. Gksudo2 is a simple bash script.  **sudo** credentials are used by gksudo2 with pkexec to **launch graphical programs as root, or AS ANOTHER LOCAL USER**. It does NOT use **xhost**, or call xauth directly. This script is **NOT SECURE** by modern standards, although **it will always send a warning notification** to the display server. Gksudo2 is not recommended on multiple networked machines, with ssh, or unless behind a firewall. Convenience is attained at the expense of security. **Use at YOUR OWN RISK**. Tested and hopefully works in multiple desktop environments, including **KDE Plasma (Xorg and Wayland), XFCE, MATE, GNOME (Xorg and Wayland), LXQT**. Works in both **systemd (Arch)** and **non-systemd (Void)** systems.  Works for **gnome-terminal**, **konsole**, **nautilus**, **dolphin** and most GUI text editors in both Wayland and Xorg. Sudo administrative rules/users/groups are used for authorization.  

## Dependencies
**bash, sudo, dbus, polkit, zenity**


## Options
Only the **--user | -u** options are actually used, and as with sudo, may be omitted for "**-u root**".  All other options accepted by the original **gksudo** are looked for and stripped.  The remaining arguments are then passed to pkexec with an environment (see below)

## Applicability
gksudo2 is designed to be fairly universal, but has not been extensively tested. Desktop environments tested so far include:
**XFCE 4.16, KDE Plasma 5 (Wayland and Xorg), MATE 1.26, LXQT 1.0, Gnome 40+ (Wayland and Xorg)**. Both **systemd** (Arch) and **non-systemd** (Void) distributions have been tested. Gksudo2 works with the following display managers: **none(startx), xdm, slim, lxdm, lightdm, gdm**. I3 and Sway have been poorly tested, but should work, as long as a polkit-agent is available.

## Details
The invoking user **must be LOCAL** and **MUST be a SUDOER**, either as an individual, or by group membership (often "wheel" or "sudo"). The **-u | --user** option allows gksudo2 to run a program as **ANY STANDARD USER, as well as root**.  

An important key feature of gksudo2 is the creation of a proper environment for sudo to use.  **/etc/environment** is sourced, and **Xauthority**, **Display**, and **wayland_display** variables are borrowed/provided, as well as a runtime directory, and some specific variables for KDE, if needed.  While this is a larger environment than the basic one pkexec uses by default, it is still (slightly) less than that of a regular user.  

gksudo2 is fully functional as-is, but if wanting more security for some commands/apps without changing sudo rules, the administrator/installer may edit or modify two variables near the beginning of the script:
- **FORCE_PASSWD_LIST**   (blank by default, listed apps will ignore cached sudo credentials, always require password)
- **NEVER_AUTH_LIST**  (prevented from running. Author's list left as default, change as desired)

## Logging
gksudo2 by default will create it's own log at **/var/log/gksudo2.log**  The entries are not errors, which usually log elsewhere, but instead simple records of the attempted calling of gksudo2, and are made whether the command actually succeeds or fails. 

## Installation
It is not difficult to install this script, but the author does not encourage "packaging" it, due to the security concerns.  To install, make sure you have sudo, polkit, and zenity, then:
- Clone the "main" branch or download the files in it.
- Move the folder/files to any desired location on the local system.
- cd  /*_your_folder_with_gksudo2_files*
- chmod +x install.sh
- sudo ./install.sh

If the "gksudo" and "gksu" commands do not exist, they will be linked to gksudo2. To remove gksudo2, run as ROOT the provided "uninstall" script.   
Optionally, if a filemanager context menu entry for gksudo2 is desired, install filemanager-gksudo2 , from here:

https://github.com/furryfixer/filemanager-gksudo2 
 
## Notes
A common warning complains about "inability to register with accessibility bus" or similar.  This warning can be silenced by appending **NO_AT_BRIDGE=1** to **/etc/environment**.

Temporary $XDG_RUNTIME_DIR directories are created separately from the standard ones.

A companion script, "filemanager-gksudo2 " is available in a separate repository. This leverages gksudo2 to provide a menu option allowing the elevation of privileges from within most common file managers.

Most web browsers will work with **"gksudo2 -u (*non-root-user*) browser"**, but will fail to run as root. Konqueror will run as root with gksudo2, but for file management only, as gksudo2 deliberately disables web browsing. Konqueror web browsing will work if called for a non-root user. 

Gksudo2 relies heavily on creating small temporary files in the /tmp directory.  Obviously, it will run faster and be easier on drives if /tmp is a tmpfs in RAM.

### Deprecated gksudo-pk Discussion
Gksudo2 is a rewrite of the deprecated gksudo-pk script, the initial focus of which was to eliminate use of pkexec. Increasing security vulnerabilities make pkexec hardly more secure than sudo. Unfortunately, KDE recently changed their apps to refuse to open with sudo, so in a partial reversion, gksudo2 uses pkexec as a pass-through, as KDE requires it. Gksudo-pk will no longer receive updates, so users of gksudo-pk should migrate to gksudo2. 
