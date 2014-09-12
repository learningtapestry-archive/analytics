class Student < ActiveRecord::Base
  belongs_to :user
  has_many :emails, through: :user

  ### Class methods

  def self.find_by_username(username)
    User.find_by_username(username).student
  end

  ### Instance methods
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
