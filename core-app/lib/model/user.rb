require 'json'
class User < ActiveRecord::Base
  has_one :student
  has_one :staff_member
  has_many :emails
  has_many :section_user
  has_many :sections, through: :section_user
  has_many :site_visits
  has_many :page_visits
  has_many :sites, through: :site_visits
  has_many :pages, through: :sites
  # has_many :spv, through: :pages, source: :pages_visited, 
  #   select: 'distinct (pages_visited.id), pages_visited.*', 
  #   conditions: proc {["pages_visited.user_id = ?",self.id]}

  # Instance methods
  def email
    # TODO return the primary email here
    self.emails.first.email
  end

  DEFAULT_SITE_TIME_FRAME = 1.week

  
  def each_site_visit(opts={})
    time_frame = opts[:time_frame] || DEFAULT_SITE_TIME_FRAME
    retval = self.site_visits
      .select("sum(time_active) as time_active, site_visits.*")
      .joins(:site,:user)
      .where(["date_visited between ? and ?", Time::now-7.days, Time::now])
      .group("site_visits.id")
    retval.each do |site_visit|
      yield site_visit
    end
    # select sum(time_active), date_visited, url, display_name from sites_visited
    # join sites on sites.id = sites_visited.site_id
    # join user on user.id = sites_visited.user_id
    # where date_visited between "#{Time.now}" and "#{Time.now-time_frame}"
    # group by date_visited, url, display_name
  end

  def each_page_visit(opts={})
    time_frame = opts[:time_frame] || DEFAULT_SITE_TIME_FRAME
    retval = self.page_visits
      .select("sum(time_active) as time_active, page_visits.*")
      .joins(:page,:user)
      .where(["date_visited between ? and ?", Time::now-7.days, Time::now])
      .group("page_visits.id")
    retval.each do |page_visit|
      yield page_visit
    end
  end


  # Instance security methods
  def hash_secret(password, password_salt)
    BCrypt::Engine.hash_secret(password, password_salt)    
  end
  def password=(password)
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = hash_secret(password, password_salt)
  end

  def password_matches?(password)
    retval = false
    if self.password_hash == hash_secret(password, password_salt) then
      retval = true
    end
    retval
  end

  # Class methods

  def self.create_user_from_json(json_str)
    json = JSON.parse(json_str)
    fields = {}
    fields[:password] = json.fetch('password')
    fields[:first_name] = json['first_name']
    fields[:last_name] = json['last_name']
    fields[:username] = json['username']
    self.create_user(fields)
  end

  # This method is used for creating users, students and staff_members
  # along with their associated relationship fields (emails and sections)

  def self.create_user(passed_fields)
    fields = passed_fields.dup
    student_fields = fields.delete(:student)
    staff_member_fields = fields.delete(:staff_member)
    primary_email = fields.delete(:email)
    fields.fetch(:password) # raise error if no password field
    user = User.new(fields)
    if student_fields
      student = Student.new(student_fields)
      user.student=student
    end
    if staff_member_fields
      staff_member = StaffMember.new(staff_member_fields)
      user.staff_member=staff_member
    end
    if primary_email
      email = Email.new(:email => primary_email, :primary => true)
      user.emails<<email
    end
    user.save
    # we return a hash so we can in the future return error messages or other supplemental
    # info back with the new user record
    {:user =>user}
  end

  def self.get_validated_user(username, password)
    if username.nil? || username.empty? || password.nil? || password.empty? then
      raise LT::ParameterMissing, "Either username or password is missing"
    end
    user = User.where(username: username).first
    if user.nil?
      raise LT::UserNotFound, "Username not found: " + username
    else 
      if !user.password_matches?(password) then
        return {:error_msg=>"Password invalid for user: #{username}", :exception => LT::PasswordInvalid}
      else
        return {:user=>user}
      end
    end
  end # GetValidatedUser

end # class User
