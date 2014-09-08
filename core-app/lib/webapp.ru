# Rackup file to load WebApp.rb server
# To run from dev CLI:
#   rackup -p 8080 webapp.ru
require 'rubygems'
require 'bundler'

Bundler.require

path = File::expand_path(File::dirname(__FILE__))
require File::join(path,'webapp.rb')
run LT::WebApp