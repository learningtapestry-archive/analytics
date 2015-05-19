$LOAD_PATH << File.expand_path('../lib', __FILE__)

#
# Rackup file to load WebApp.rb server
# To run from dev CLI:
#   rackup -p 8080 config.ru
#
require File.expand_path('../config/environment',  __FILE__)
run Analytics::WebApp
