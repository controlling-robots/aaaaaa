#!/bin/expect 
spawn dpkg-reconfigure gdm3 -freadline
expect "Default display manager:"
send "2\r"
expect eof