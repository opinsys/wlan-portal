#!/usr/bin/ruby

`arp -a`.split("\n").each do |line|
  ip = line[/\([0-9.]+\)/]
  ip = ip[/[0-9.]+/]
  puts "/usr/sbin/rmtrack #{ip}"
  `./rmtrack #{ip}`
end
