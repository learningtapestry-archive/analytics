# cf. https://github.com/james2m/seedbank
# Don't create seeds here - use file specific seeds
# Use folders to create seeds specific to certain environments. E.g.,
#   ./test/raw_messages.seeds.rb to seed the testing database
# For table data that are common across all environments create files
# In this folder: ./approved_sites.seeds.rb
LT::Janitor::Seeds::seed!
