# gksudo2
## Gksudo alternative/replacement for X11 or Wayland
### gksudo2 [-u | --user \<user\>] \<command\>
#### gksudo [-u | --user \<user\>] \<command\>
#### gksu [-u | --user \<user\>] \<command\>
#### REPLACES DEPRECATED gksudo/gksu as well as gksudo-pk. If looking for gksudo-pk, see notes at the end.
A drop-in replacement for **gksu** and **gksudo**, with fewer options. **WORKS FOR WAYLAND** as well as for X11. Gksudo2 is a simple bash script.  **sudo** credentials are used by gksudo2 to **launch graphical programs as root, or AS ANOTHER USER**. Environment safeguards (somewhat similar to pkexec) are provided. It does not call xauth directly, or use xhost for X11, but xhost is required if wayland. This script is **NOT SECURE** by modern standards, although **it will always send a warning notification** to the display server. Pkexec is no longer used. Gksudo2 is not recommended on multiple networked machines, with ssh, or unless behind a firewall. Convenience is attained at the expense of security. **Use at YOUR OWN RISK**. Tested and hopefully works in multiple desktop environments, including **KDE Plasma (Xorg and Wayland), XFCE, MATE, GNOME (Xorg and Wayland), LXQT**. Works in both **systemd (Arch)** and **non-systemd (Void)** systems.  Works for **gnome-terminal**, **konsole**, **nautilus**, **dolphin** and most GUI text editors in both Wayland and Xorg. Sudo administrative rules/users/groups are used for authorization.  Updated in October 2022.

## Dependencies
**bash, sudo, dbus, zenity**


## Options
Only the **--user | -u** options are actually used, and as with sudo, may be omitted for "**-u root**".  All other options accepted by the original **gksudo** are looked for and stripped.  The remaining arguments are then passed to pkexec with an environment (see below)

## Applicability
gksudo2 is designed to be fairly universal, but has not been extensively tested. Desktop environments tested so far include:
**XFCE 4.16, KDE Plasma 5 (Wayland and Xorg), MATE 1.26, LXQT 1.0, Gnome 40+ (Wayland and Xorg)**. Both **systemd** (Arch) and **non-systemd** (Void) distributions have been tested. Gksudo2 works with the following display managers: **none(startx), xdm, slim, lxdm, lightdm, gdm**. I3 and Sway have been poorly tested, but should work.

## Details
The invoking user **MUST be a SUDOER**, either as an individual, or by group membership (often "wheel" or "sudo"). The **-u | --user** option allows gksudo2 to run a program as **ANY STANDARD USER, as well as root**.  

An important key feature of gksudo2 is the creation of a proper environment for sudo to use.  **/etc/environment** is sourced, and **Xauthority**, **Display**, and **wayland_display** variables are borrowed/provided, as well as a runtime directory, and some specific variables for KDE, if needed.  While this is a larger environment than the basic one pkexec uses by default, it is still (slightly) less than that of a regular user.  

gksudo2 is fully functional as-is, but if wanting more security for some commands/apps without changing sudo rules, the administrator/installer may edit or modify two variables near the beginning of the script:
- **FORCE_PASSWD_LIST**   (blank by default, listed apps will ignore cached sudo credentials, always require password)
- **NEVER_AUTH_LIST**  (prevented from running. Author's list left as default, change as desired)

## Logging
gksudo2 by default will create it's own log at **/var/log/gksudo2.log**  The entries are not errors, which usually log elsewhere, but instead simple records of the attempted calling of gksudo2, and are made whether the command actually succeeds or fails. 

## Installation
It is not difficult to install this script, but the author does not encourage "packaging" it, due to the security concerns.  To install, install sudo and zenity, then download both **gksudo2** and **gksudo-su** scripts. Ensure that $PATH includes /usr/local/bin, unless placing the links in /bin or /usr/bin instead. From the download directory, do the following AS ROOT:

- cp gksudo2 /usr/local/bin/
- cp gksudo-su /usr/local/bin/
- chmod 0755 /usr/local/bin/gksudo2
- chmod 0744 /usr/local/bin/gksudo-su
- ln -s /usr/local/bin/gksudo2 /usr/local/bin/gksudo   # recommended to replace "gksudo"
- ln -s /usr/local/bin/gksudo2 /usr/local/bin/gksu     # recommended to replace "gksu"

Optionally install filemanager-gksudo2 , from here:

https://github.com/furryfixer/filemanager-gksudo2 
 
## Notes
A common warning complains about "inability to register with accessibility bus" or similar.  This warning can be silenced by appending **NO_AT_BRIDGE=1** to **/etc/environment**.

Temporary $XDG_RUNTIME_DIR directories are created separately from the standard ones.

A companion script, "filemanager-gksudo2 " is available in a separate repository. This leverages gksudo2 to provide a menu option allowing the elevation of privileges from within most common file managers. You will be warned when doing this. In single or 2-3 user situations, this can be very convenient for EXAMINING protected files or directories, but should not be abused by indiscriminately (or accidentaly) deleting or modifying them with gksudo2.  Never elevate to superuser when there is no need.

The script relies heavily on creating small temporary files in the /tmp directory.  Obviously, it will run faster and be easier on drives if /tmp is a tmpfs in RAM.

### Deprecated gksudo-pk Discussion
Increasing security vulnerabilities make pkexec hardly more secure than sudo. Sudo was still required for the script in addition to polkit.  gksudo2 provides some limits on environment just as pkexec does, for the purposes of this script. Custom polkit rules and actions are unnecessary with pure sudo.  For these reasons, the old gksudo-pk script was abandoned for gksudo2.  Note that the old (gksudo-pk) version of gksudo-su will NOT work with gksudo2.
