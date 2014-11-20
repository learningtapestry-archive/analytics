#!/usr/bin/env ruby

#ansible -i hosts-prod.rb web01 -m service -a "name=nginx state=started"
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
              ansible_ssh_user: "root"
            },
            db01: {
              ansible_ssh_host: "db01.learningtapestry.com",
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
        # ideally, this lives in vars/main.yml, but can't get it to work now
        :"all:vars" => {ansible_ssh_user: "root"}
      }
    end
  end
end
puts LT::Ansible::production_inventory.to_json