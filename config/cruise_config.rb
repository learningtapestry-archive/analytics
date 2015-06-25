Project.configure do |project|
  project.email_notifier.emails = ['deivid.rodriguez@gmail.com']
  project.email_notifier.from = 'learntac-build@betaspaces.com'

  # Build the project by invoking rake task 'custom'
  project.rake_task = 'test'

  project.scheduler.polling_interval = 5.minutes
  project.scheduler.always_build = false # build only when there are source control changes

  # Set environment variables passed into the build
  project.environment['RACK_ENV'] = 'test'

  # Set any args for bundler here
  project.bundler_args = "--path=#{project.gem_install_path} --gemfile=#{project.gemfile} --no-color --local"
end
