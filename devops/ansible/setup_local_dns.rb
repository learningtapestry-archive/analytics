#!/usr/bin/ruby
# this file will add digital ocean's DNS servers to your computer's list
# it will add them first, so they are asked and when they fail to answer
# your other dns servers will respond
# This enables you to create/delete dns entries for machines (and machine themselves)
# on DO quickly, and have the changes in DNS reflected immediately on your machine.
# You may notice some initial ill-effects, where your web browser can't do dns lookups.
# This seems to clear up after a short period, so don't give up in the first 5 minutes.
# run this file as "sudo" if you don't have rights to edit the dhclient.conf file.
# and/or if you need sudo to call "service network-manager restart"

dhclient = '/etc/dhcp/dhclient.conf'
host = `host ns1.digitalocean.com`
ns_server_ip = host.match(/address\s*([0-9.]+)/)[1]
prepend_cmd = "prepend domain-name-servers #{ns_server_ip}\n"
file = File::read(dhclient)
if file.match(/^#{prepend_cmd}/) then
  puts "DNS command line already exists on machine."
  puts "  in file #{dhclient}"
  puts "  cmd: #{prepend_cmd}"
  exit
end
file = ""
puts "Adding IP to dhcp domain name servers: #{ns_server_ip}"
line_added = false
File::open(dhclient) do |dhc|
  dhc.each do |line|
    file+=line
    if line.match(/^#\s*prepend/) then
      file+=prepend_cmd
      line_added = true
    end
  end
end
if File::write(dhclient, file)<file.length then
  puts "Error writing to file #{dhcclient}. Did you run as sudo?"
end
puts "Error: failed to add DNS line to #{dhclient}" if !line_added
puts "Restarting network-manager to pickup changes to file..."
`service network-manager restart`