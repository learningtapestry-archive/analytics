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
        local: {
          hosts:["127.0.0.1"],
          vars: { 
            ansible_connection: "local"
          }
        },
        common: {
          hosts: [],
          children: ["web", "db"]
        },
        web: {
          hosts: [],
          children: ["web_staging"]
        },
        db: {
          hosts: [],
          children: ["db_staging"]
        },
        web_staging: {
          hosts: ["webdb01-ci"],
          vars: {
            ansible_connection: "ssh",
            lt_env: "test",
            lt_code_folder: "/home/lt_admin/.cruise/projects/learning_tapestry"
          }
        },
        db_staging: {
          hosts: ["webdb01-ci"],
          vars: {
            ansible_connection: "ssh",
            lt_env: "test"
          }
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
