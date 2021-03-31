#!/bin/bash

apt install -y lightdm expect > /dev/null

dpkg --configure -a

echo "...DPKG-RECONF SERVICE"
expect reconf.bash

#dpkg-reconfigure gdm3

apt install -y x11vnc > /dev/null

echo "...INSTALL SERVICE"
touch /etc/systemd/system/x11vnc.service
cat >/etc/systemd/system/x11vnc.service <<EOT
# Description: Custom Service Unit file
# File: /etc/systemd/system/x11vnc.service
[Unit]
Description="x11vnc"
Requires=display-manager.service
After=display-manager.service

[Service]
ExecStart=/usr/bin/x11vnc -loop -nopw -xkb -repeat -noxrecord -noxfixes -noxdamage -forever -rfbport 5900 -display :0 -auth guess
ExecStop=/usr/bin/killall x11vnc
Restart=on-failure
RestartSec=2

[Install]
WantedBy=multi-user.target
EOT

echo "...START SERVICE"
systemctl enable x11vnc.service

echo "...REBOOT"
sleep 1

reboot