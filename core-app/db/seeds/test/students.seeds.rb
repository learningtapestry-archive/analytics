# create a user in a section
module LT
  module Seeds
    module Students class << self
      def create_joe_smith_scenario
        retval = {
          :student=>{
            :username=>"joesmith@foo.com",
            :password=>"pass",
            :first_name=>"Joe",
            :last_name=>"Smith",
            :email=> "joesmith@foo.com",
            :student=>{
            }
          },
          :section=>{
            :name=>"CompSci Period 2",
            :section_code=>"Comp Sci Room 2"
          },
          :teacher=>{
            :username=>"janedoe@bar.com",
            :password=>"pass",
            :first_name=>"Jane",
            :last_name=>"Doe",
            :email=> "janedoe@bar.com",
            :staff_member=>{
              :staff_member_type=>'teacher'
            }
          }
        }
        student = User.create_user(retval[:student])[:user].student
        teacher = User.create_user(retval[:teacher])[:user].staff_member
        section = Section.create(retval[:section])
        student.add_to_section(section)
        teacher.add_to_section(section)
        retval
      end # create_joe_smith_seed
    end; end
  end
end