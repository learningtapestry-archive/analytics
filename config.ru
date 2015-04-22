$LOAD_PATH << File.expand_path('../lib', __FILE__)

# Rackup file to load WebApp.rb server
# To run from dev CLI:
#   rackup -p 8080 config.ru
require 'bundler'
Bundler.setup

require 'lt/core'

path = File::expand_path(File::dirname(__FILE__))
LT::Environment.boot_all(path)

require 'webapp'
puts "Running in enviroment: #{LT.environment.run_env}"

Analytics::WebApp.boot
run Analytics::WebApp
