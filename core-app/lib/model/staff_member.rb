class StaffMember < ActiveRecord::Base
  belongs_to :user
  has_many :emails, through: :user
  has_one :organization, through: :user
  has_one :school, through: :user
  delegate :page_visits, :to => :user
  delegate :site_visits, :to => :user
  delegate :sections, :to => :user
  delegate :full_name, :to => :user
  delegate :first_name, :to => :user
  delegate :last_name, :to => :user
  delegate :username, :to => :user
  delegate :email, :to => :user
  delegate :each_site_visit, :to => :user
  delegate :each_page_visit, :to => :user

  def add_to_section(section, user_type=self.staff_member_type)
    #self.user.sections << section
    # this creates a section user entry, attaches section to it,
    #   and sets the section_user.user_type correctly
    self.user.section_user.create(:section=>section, :user_type=>user_type)
    self.save
  end

  def user_type
    self.staff_member_type
  end

  ### Class methods

  def self.find_by_username(username)
    User.find_by_username(username).staff_member
  end

  def add_to_school(school)
    self.user.school = school
    self.user.save
  end

end
