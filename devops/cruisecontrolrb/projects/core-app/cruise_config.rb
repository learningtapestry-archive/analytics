Project.configure do |project|

  project.email_notifier.emails = ['jasonhoekstra@gmail.com']
  project.email_notifier.from = 'learntac-build@betaspaces.com'

  # Build the project by invoking rake task 'custom'
  # project.rake_task = 'custom'

  # Build the project by invoking shell script "build_my_app.sh". Keep in mind that when the script is invoked,
  project.build_command = './core-app/run-tests.sh'

  project.scheduler.polling_interval = 5.minutes
  project.scheduler.always_build = false # build only when there are source control changes
   
  # Set environment variables passed into the build
  project.environment['RACK_ENV'] = 'test'
  project.environment['RAILS_ENV'] = 'test'

  # Set any args for bundler here
  # Defaults to '--path=#{project.gem_install_path} --gemfile=#{project.gemfile} --no-color'
  # project.bundler_args = "--path=#{project.gem_install_path} --gemfile=#{project.gemfile} --no-color --local"
end
