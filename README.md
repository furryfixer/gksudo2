# gksudo2
## GUI open as Root or Other User, for Wayland and X11, in Plasma, Gnome, XFCE, LXQT, MATE, Sway, Niri, Hyprland, Wayfire.
### gksudo2 [-u | --user \<user\>] \<command\>
#### gksudo [-u | --user \<user\>] \<command\>
#### gksu [-u | --user \<user\>] \<command\>
A drop-in replacement for **gksu** and **gksudo**, with fewer options. **WORKS FOR WAYLAND** as well as for X11. Gksudo2 is a simple bash script.  **sudo** credentials are used by gksudo2 with pkexec to **launch graphical programs as root, or AS ANOTHER LOCAL USER**. This script is **NOT SECURE** by modern standards, although **it will always send a warning notification** to the display server. Gksudo2 is not recommended on multiple networked machines, with ssh, or unless behind a firewall. Convenience is attained at the expense of security. **Use at YOUR OWN RISK**. Tested and works in multiple desktop environments, including **KDE Plasma, XFCE, MATE, GNOME, LXQT, Niri, Wayfire, Sway, Hyprland**. Works in both **systemd (Arch)** and **non-systemd (Void)** systems.  Tested for popular terminal emulators like **kgx, gnome-terminal, konsole, mate-terminal, qterminal, lxterminal, foot, xterm, alacritty**, and many common file managers and  GUI text editors in both Wayland and Xorg. Sudo administrative rules/users/groups are used for authorization. 

## Dependencies
**bash, sudo, dbus, dbus-launch** -which is often the **dbus-x11** package in older systems, **polkit (and a polkit agent), zenity** (gtk) or **qarma** (qt). **xdg-desktop-portal-gtk** is required on Wayland. If using **dbus-broker-units**, dbus-launch is likely included. X11 apps require functioning Xwayland for a Wayland desktop. (For example, Niri would require "xwayland-satellite").

Optional: **xhost**, needed for older X11-only apps like xterm, to run as another user with Xwayland. This may be in an "x11-xserver-utils" or "xorg-xhost" package, depending on distribution.


## Options
Only the **--user | -u** options are actually used, and as with sudo, may be omitted for "**-u root**".  All other options accepted by the original **gksudo** are looked for and stripped.  The remaining arguments are then passed to pkexec with an environment (see below)

## Applicability
gksudo2 is designed to be fairly universal. Desktop environments tested so far include:
**XFCE 4.2, KDE Plasma 6 (Wayland and Xorg), MATE 1.28, LXQT 2.2, Gnome 49 (Wayland and (Xorg for versions<49), Sway, Niri, Hyprland, Wayfire.**. Both **systemd** (Arch) and **non-systemd** (Void) distributions have been tested. Gksudo2 works with the following display managers: **none(startx), sddm, xdm, slim, lxdm, lightdm, gdm**. On more alacarte or minmal desktop environments, a polkit agent must be started, and xdg-portal-desktop-gtk needs proper configuration.

## Details
The invoking user **must be LOCAL** and **MUST be a SUDOER**, either as an individual, or by group membership (often "wheel" or "sudo"). The **-u | --user** option allows gksudo2 to run a program as **ANY STANDARD LOCAL USER, as well as root**.

An important key feature of gksudo2 is the creation of a proper environment for sudo to use.  **/etc/environment** is sourced, and **Xauthority**, **Display**, and **wayland_display** variables are borrowed/provided, as well as a runtime directory, and some specific variables for KDE, if needed.  While this is a larger environment than the basic one pkexec uses by default, it is still (slightly) less than that of a regular user.  

gksudo2 is fully functional as-is, but if wanting more security for some commands/apps without changing sudo rules, the administrator/installer may edit or modify two variables near the beginning of the script:
- **FORCE_PASSWD_LIST**   (blank by default, listed apps will ignore cached sudo credentials, always require password)
- **NEVER_AUTH_LIST**  (prevented from running. Author's list left as default, change as desired)

## Logging
gksudo2 by default will create it's own log at **/var/log/gksudo2.log**  The entries are not errors, which usually log elsewhere, but instead simple records of the attempted calling of gksudo2, and are made whether the command actually succeeds or fails. 

## Installation
It is not difficult to install this script, but the author does not encourage "packaging" it, due to the security concerns.  To install, make sure you have sudo, polkit, and zenity/qarma, then:
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

For an active mate-session, Caja works fine when called by gksudo2 for non-root users, but the process may hang on closing window, requiring manual interrupt to continue bash session it was called from.

Gksudo2 relies heavily on creating small temporary files in the /tmp directory.  Obviously, it will run faster and be easier on drives if /tmp is a tmpfs in RAM.

"xhost" is used only as a fall-back option by gksudo2. This is required for older X11 apps on Xwayland that have no native wayland interface, like xterm.

If text is missing on Zenity notification windows, xdg-desktop-portal-gtk may not be properly configured. Even so, this may be a problem, particularly with Nvidia Wayland drivers. (see below)

Users have wondered why gksudo2 does NOT use dbus-run-session, instead of dbus-launch. Actually, dbus-run-session IS used where possible. Unfortunately, dbus-run-session partially unravels what the script sets up, so that apps started with gksudo2 have a dbus session bus that is isolated from the system bus. dbus-launch avoids this.

## CHANGELOG 7/2026

- Added xhost as a fall-back option. gksudo2 requires this for some older X11-only apps (xterm), mostly on Xwayland.

- Fixed blank text on Wayland zenity dialogs when switching users by using dbus-run-session or dbus-launch to call zenity, This mostly occurs with nvidia Wayland drivers, . Qarma did not require this. (This change can hopefully be reversed in future).

- Added a scrollable zenity dialog where longer error messages/warnings are anticipated.

- Minor Code clean-up 
