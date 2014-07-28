#!/usr/bin/ruby

require 'csv'
require 'json'

##
# {
#    "id": "12345678-1234-5678-1234-567812345678",
#    "actor":{
#        "mbox":"mailto:xapi@adlnet.gov"
#    },
#    "verb":{
#        "id":"http://adlnet.gov/expapi/verbs/created",
#        "display":{
#            "en-US":"created"
#        }
#    },
#    "object":{
#        "id":"http://example.adlnet.gov/xapi/example/activity"
#    }
# }

ACTION_VERBS = Array["answered", "completed", "experienced", "failed", "passed", "scored"]
ACTIVITIES = Array["assessment", "course", "interaction", "lesson", "media", "question"]

puts "\n*** xAPI Test Data Generator ***\n"
puts "This script will generate test data in the xAPI format various different actions as selected."
puts "---------------------------------------------------------------------------------------------\n\n"

print "User list file name [students.txt]: "
user_file_name = gets.chomp
if user_file_name.length == 0
	user_file_name = "students.txt"
end
puts

print "Output data directory [./data]: "
data_directory = gets.chomp
if data_directory.to_s == ""
	data_directory = "./data"
end
puts

print "Number of records to generate [100]: "
record_count = gets.chomp
if record_count.to_s == "" or !record_count.is_a? Integer
	record_count = 100
end
puts

puts "Action types available: " + ACTION_VERBS.join(", ");
print "Type of actions to generate (all or comma separated list) [all]: "
verbs = gets.chomp
if verbs.to_s == ""
	verbs = "all"
end
puts

puts "---------------------------------------------------------------------------------------------\n\n"
puts "Ready to generate test xAPI data using the following parameters:"
puts "User list file name: " + user_file_name
puts "Output data directory: " + data_directory
puts "Number of records: " + record_count.to_s
puts "Action type(s): " + verbs
puts
print "Generate data? [Y/n] "
go = gets.chomp.downcase

if go == "y" or go == ""
	students = CSV.read(user_file_name)

	student_list = []

	## Check to see if file header is in the format
	if students 
		if students.size > 1 and students[0] == ["StudentID", "FirstName", "LastName", "Email"]
			for index in 1 ... students.size
				student = { :student_id => students[index][0],
							:first_name => students[index][1],
							:last_name => students[index][2],
							:email => students[index][3] }
				student_list.push(student)
  				##puts "students[#{index}] = #{students[index].inspect}"
  			end
		end
	end

	puts JSON.pretty_generate student_list

	#for index in 0 ... students.size
  		#puts "students[#{index}] = #{students[index].inspect}"
	#end
end