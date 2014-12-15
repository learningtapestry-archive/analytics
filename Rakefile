# Load Rakefile from core-app
cwd = File::expand_path(File::dirname(__FILE__))
core_app = File::join(cwd,'core-app')
Dir.chdir(core_app)
load './Rakefile'

namespace :build do
  # Cruise Control will call this task if it exists
  task :core_app do
    puts "Building core-app project..."
    puts "Running in dir: #{Dir::pwd}"
    puts "Running `sudo bundle install`"
    puts `sudo bundle install`
    puts "Running `sudo bundle update`"
    puts `sudo bundle update`
    Rake::Task["full_tests"].invoke
  end
end