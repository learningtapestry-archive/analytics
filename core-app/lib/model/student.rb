class Student < ActiveRecord::Base
  belongs_to :user
  has_many :emails, through: :user

  ### Class methods

  def self.find_by_username(username)
    User.find_by_username(username).student
  end

  ### Instance methods
  def add_to_section(section, user_type="Student")
    #self.user.sections << section
    # this creates a section user entry, attaches section to it,
    #   and sets the section_user.user_type correctly
    self.user.section_user.create(:section=>section, :user_type=>user_type)
    self.user.save
  end
  def first_name
    self.user.first_name
  end
  def last_name
    self.user.last_name
  end
  def username
    self.user.username
  end
  def email
    self.user.email
  end

end
