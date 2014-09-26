# Rackup file to load WebApp.rb server
# To run from dev CLI:
#   rackup -p 8080 webapp.ru
require 'rubygems'
require 'bundler'
require './lib/lt_base.rb'

Bundler.require

LT::boot_all
path = File::expand_path(File::dirname(__FILE__))
require File::join(path,'webapp.rb')
puts "Run enviroment mode: #{LT::run_env}"
run LT::WebApp