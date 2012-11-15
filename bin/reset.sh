#!/bin/sh

./iptables.sh
/usr/bin/ruby arp_rmtrack.rb
