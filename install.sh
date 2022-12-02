#!/bin/bash
##########################################################################
# GKSUDO2 install script, by William Rueger (furryfixer)
# You must run with sudo or as ROOT!
##########################################################################

# user must be root
if [ "$(id -u)" != "0" ]; then
   echo "Installation must be run as root" 1>&2
   exit 1
fi
echo "Installing gksudo2...
"
echo "Removing any previous installed files and folders...
"
[[ -L /usr/local/bin/gksudo ]] && rm -v /usr/local/bin/gksudo
[[ -L /usr/local/bin/gksu ]] && rm -v /usr/local/bin/gksu
[[ -L /usr/bin/gksudo ]] && rm -v /usr/bin/gksudo
[[ -L /usr/bin/gksu ]] && rm -v /usr/bin/gksu
[[ -f /usr/local/bin/gksudo2 ]] && rm -v /usr/local/bin/gksudo2
[[ -f /usr/local/bin/gksudo2-su ]] && rm -v /usr/local/bin/gksudo2-su
[[ -f /usr/bin/gksudo2 ]] && rm -v /usr/bin/gksudo2
[[ -f /usr/bin/gksudo2-su ]] && rm -v /usr/bin/gksudo2-su
[[ -f  /usr/share/polkit-1/actions/gksudo2.gk.env.cmd.policy ]] && rm -v /usr/share/polkit-1/actions/gksudo2.gk.env.cmd.policy
[[ -f  /etc/polkit-1/rules.d/47-gksudo2-gk-env-cmd.rules ]] && rm -v /etc/polkit-1/rules.d/47-gksudo2-gk-env-cmd.rules
# Check PATH
if grep -q "/usr/local/bin" <<< $PATH; then
	prefix="/usr/local/bin"
	mkdir -p /usr/local/bin
else
	echo "
\"/usr/local/bin\" is not in System \$PATH
Executable files will be placed in \"/usr/bin\" instead.

Press <Enter> key to continue."
read a
	prefix="/usr/bin"
fi
echo "
Copying new files..."
mkdir -p /etc/polkit-1/rules.d
cp -v gksudo2 $prefix/
cp -v gksudo2-su $prefix/
# cp -v gksudo2.gk.env.cmd.policy /usr/share/polkit-1/actions/ # deprecated
# cp -v 47-gksudo2-gk-env-cmd.rules /etc/polkit-1/rules.d/     # deprecated
chmod -v 0755 $prefix/gksudo2
chmod -v 0744 $prefix/gksudo2-su
ln -v -s $prefix/gksudo2 $prefix/gksudo   # recommended to replace "gksudo"
ln -v -s $prefix/gksudo2 $prefix/gksu     # recommended to replace "gksu"
echo "
Installation sucessfully completed.

See github repository \"filemanager-gksudo2\" if a filemanager context
	menu entry for gksudo2 is desired.
"
