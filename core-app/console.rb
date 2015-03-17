### Learning Tapestry Dev Console

COMMANDS = [
  'rake db:create',
  'rake db:drop',
  'rake db:migrate',
  'rake db:rollback',
  'rake db:seed',
  'rake lt:console',
  'rake lt:janitors:extract_meta_data',
  'rake lt:janitors:process_redis_messages',
  'rake lt:janitors:raw_messages_to_page_visits',
  'rake lt:janitors:raw_messages_to_video_views',
  'rake lt:janitors:redis_to_raw_messages',
  'rake lt:seed',
  'rake lt:test:run_full_tests',
  'rake lt:test:run_test',
  'rake lt:test:run_tests',
  'rake lt:webapp:start_dev'
]

system 'clear' or system 'cls'

command_number = 1

COMMANDS.each do |command|
  print command_number.to_s + '          ' + command + "\n"
  command_number += 1
end

print "\n"
print 'Command: '

command_input = gets.chomp
execute_command = COMMANDS[(command_input.to_i-1)]

if (execute_command == 'rake lt:test:run_test')
  tests = Dir["test/**/*_test.rb"]
  test_count = 0
  tests.each do |test|
    puts "#{(test_count+1)} - " + test[5..test.length]
    test_count += 1
  end

  test_name = gets.chomp
  execute_command = execute_command + "[#{tests[test_name.to_i-1]}]"
end

exec( execute_command )