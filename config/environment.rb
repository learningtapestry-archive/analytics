require 'bundler'
Bundler.setup

require 'lt/core'
LT::Environment.boot_all(Dir.pwd, ENV['RACK_ENV'])

require 'webapp'
Analytics::WebApp.boot
