require 'bundler'
Bundler.setup

require 'lt/core'
LT::Environment.boot_all(Dir.pwd)

require 'webapp'
Analytics::WebApp.boot
