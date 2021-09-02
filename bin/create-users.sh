#!/bin/bash

test -f /etc/users.list || exit 0

while read username hash; do
        # Skip, if user already exists
        grep ^$username /etc/passwd && continue
        # Create user
        useradd -m -ou 0 -s /bin/fish -g 0 $username
        # Set password
        echo "$username:$hash" | /usr/sbin/chpasswd -e
        # Copy launchers
        mkdir /home/$username/Desktop
        cp /usr/share/RenameMyTVSeries/RenameMyTVSeries.desktop /home/$username/Desktop/RenameMyTVSeries.desktop
	echo "xfce4-session" >> /home/$username/.xsession
done < /etc/users.list
