#!/usr/bin/env ruby
# this file must be executable (chmod +x) in order for ansible to use it
# sample commands to test the file:
# ansible -i hosts-prod.rb web01 -m service -a "name=nginx state=started"
# ansible -i hosts-prod.rb all -m ping
require 'json'
module LT
  module Ansible
    def self.staging_inventory
      {
        boxen_staging: {
          hosts: [],
          children: ["web_staging", "db_staging"],
          vars: {
            ansible_connection: "local"
          }
        },
        web_staging: {
          hosts: ["web01-staging"]
        },
        db_staging: {
          hosts: ["db01-staging"]
        }
      }
    end
  end
end
# ansible will pass "--list" to this file when run from command line
# testing for --list should let us require this file in code libraries as well
if ARGV.find_index("--list") then
  puts LT::Ansible::staging_inventory.to_json
end