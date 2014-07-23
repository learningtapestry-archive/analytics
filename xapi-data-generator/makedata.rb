#!/usr/bin/ruby

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

action_verbs = Array["answered", "completed", "experienced", "failed", "passed", "scored"]
activities = Array["assessment", "course", "interaction", "lesson", "media", "question"]

puts "\n*** xAPI Test Data Generator ***\n"
puts "This script will generate test data in the xAPI format various different actions as selected."
puts "---------------------------------------------------------------------------------------------\n\n"

print "User list file name [students.txt]: "
user_file_name = gets.chomp

print "Output data directory [./data]: "
user_file_name = gets.chomp

print "Number of records to generate [100]: "
record_count = gets.chomp

print "Action types available: "
print "Type of actions to generate "
