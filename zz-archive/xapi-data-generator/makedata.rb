#!/usr/bin/ruby

require 'csv'
require 'json'
require 'securerandom'

def get_random_item(list)
	if list 
		return list[Random.rand(list.size)]
	else
		return nil
	end
end

puts "\n*** xAPI Test Data Generator ***\n"
puts "This script will generate test data in the xAPI format various different actions as selected."
puts "---------------------------------------------------------------------------------------------\n\n"

print "User list file name [students.csv]: "
user_file_name = gets.chomp
if user_file_name.length == 0
	user_file_name = "students.csv"
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

## Temporarily until can enumerate from CSV table

#puts "Action types available: " + ACTION_VERBS.join(", ");
#print "Type of actions to generate (all or comma separated list) [all]: "
#verbs = gets.chomp
#if verbs.to_s == ""
	verbs = "all"
#end
#puts

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
	students = CSV.read(user_file_name, :headers => true)
	activities = CSV.read("activites.csv", :headers => true)
	verbs = CSV.read("verbs.csv", :headers => true)
	student_list = []

	if students 
		if students.size > 0 and 
			students.headers.include?("student_id") and
			students.headers.include?("first_name") and
			students.headers.include?("last_name") and
			students.headers.include?("email")			
			for index in 0 ... students.size
				verb = get_random_item(verbs)
				student = { :id => SecureRandom.uuid,
							:actor => {
								:mbox => students[index]["email"],
								:name => students[index]["first_name"] + " " + students[index]["last_name"],
								:id => students[index]["student_id"]
							},
							:verb => {
								:id => verb["uri"],
								:display => {
									:en => verb["name"]
								}
							},
							:object => {
								:id => "http://object.null/object_id"
							}
						}
				student_list.push(student)
  			end
		end
	end

	puts JSON.pretty_generate student_list
end

