# create a user in a section
module LT
  module Seeds
    module Students class << self
      def create_joe_smith
        seed = {
          :username=>"joesmith@foobar.com",
          :password=>"pass",
          :first_name=>"Joe",
          :last_name=>"Smith",
          :student=>{
          },
          :email=> "joesmith@foobar.com"
        }
        user = User.create_user(seed)
        seed
      end # create_joe_smith_seed
    end; end
  end
end