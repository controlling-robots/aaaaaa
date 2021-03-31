#!/bin/bash

apt install -y lightdm expect

dpkg --configure -a

expect spawn dpkg-reconfigure gdm3 -freadline
expect "Default display manager:"
send "2\r"
expect eof

#dpkg-reconfigure gdm3

apt install -y x11vnc

touch /etc/systemd/system/x11vnc.service

cat >/etc/systemd/system/x11vnc.service <<EOL
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
EOL

systemctl enable x11vnc.service

reboot