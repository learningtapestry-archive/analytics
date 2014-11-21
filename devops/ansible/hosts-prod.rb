#!/usr/bin/env ruby
# this file must be executable (chmod +x) in order for ansible to use it
# sample commands to test the file:
# ansible -i hosts-prod.rb web01 -m service -a "name=nginx state=started"
# ansible -i hosts-prod.rb all -m ping
require 'json'
module LT
  module Ansible
    def self.production_inventory
      {
        # 
        :"_meta" => {
          hostvars: {
            web01: {
              ansible_ssh_host: "web01.learningtapestry.com",
              # ideally, this lives in vars/main.yml, but can't get it to work now
              ansible_ssh_user: "root"
            },
            db01: {
              ansible_ssh_host: "db01.learningtapestry.com",
              # ideally, this lives in vars/main.yml, but can't get it to work now
              ansible_ssh_user: "root"
            }
          }
        },
        webservers: {
          hosts: ["web01"]
        },
        dbservers: {
          hosts: ["db01"]
        },
      }
    end
  end
end
# ansible will pass "--list" to this file when run from command line
# testing for --list should let us require this file in code libraries as well
if ARGV.find_index("--list") then
  puts LT::Ansible::production_inventory.to_json
end