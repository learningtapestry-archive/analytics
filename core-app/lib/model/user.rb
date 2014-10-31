require 'json'
class User < ActiveRecord::Base
  has_secure_password :validations => false
  has_one :student
  has_one :staff_member
  belongs_to :organization
  belongs_to :school
  has_many :emails
  has_many :section_user
  has_many :sections, through: :section_user
  has_many :page_visits
  has_many :sites
  has_many :pages, through: :sites

  # Instance methods
  def email
    # TODO return the primary email here
    self.emails.first.email
  end

  DEFAULT_VISIT_TIME_FRAME = 1.week

  def full_name
    retval = "#{first_name} #{middle_name} #{last_name}"
    # reduce double spaces to single and any spaces front/back
    retval.gsub(/\s\s+/," ").strip
  end

  # returns aggregate site visits for this user as a user object
  def site_visits_summary(opts={})
    begin_date = opts[:begin_date] || Time::now
    end_date = opts[:end_date] || Time::now
    site_visits = Site
      .select(Site.arel_table[:id])
      .select(Site.arel_table[:display_name])
      .select(Site.arel_table[:url])
      .select(PageVisit.arel_table[:time_active].sum.as("time_active"))
      .joins("JOIN pages ON pages.site_id = sites.id")
      .joins("JOIN page_visits ON page_visits.page_id = pages.id")
      .joins("JOIN users ON users.id = page_visits.user_id")
      .where(["page_visits.date_visited BETWEEN SYMMETRIC ? and ?", begin_date, end_date])
      .where(["users.id = ?", self.id])
      .group(Site.arel_table[:id])
      .group(Site.arel_table[:display_name])
      .group(Site.arel_table[:url])
      .order("time_active DESC")
    site_visits
  end

  # returns aggregate site visits for this user as a user object
  def page_visits_summary(opts={})
    begin_date = opts[:begin_date] || Time::now
    end_date = opts[:end_date] || Time::now
    site = opts.fetch(:site)
    site_id = if site.kind_of?(Site) then
      site.id
    elsif site.respond_to?(:site_id)
      site.site_id
    else
      raise LT::InvalidParameter.new("Bad Site parameter in each_page_visit")
    end
    page_visits = Page
      .select(Page.arel_table[:id])
      .select(Page.arel_table[:display_name])
      .select(Page.arel_table[:url])
      .select(PageVisit.arel_table[:time_active].sum.as("time_active"))
      .joins("JOIN sites ON sites.id = pages.site_id")
      .joins("JOIN page_visits ON page_visits.page_id = pages.id")
      .joins("JOIN users ON users.id = page_visits.user_id")
      .where(["page_visits.date_visited BETWEEN SYMMETRIC ? and ?", begin_date, end_date])
      .where(["sites.id = ?", site_id])
      .where(["users.id = ?", self.id])
      .group(Page.arel_table[:id])
      .group(Page.arel_table[:display_name])
      .group(Page.arel_table[:url])
      .order("time_active DESC")
    page_visits
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
    retval = {}
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
    begin
      user.save
    rescue ActiveRecord::StatementInvalid, ActiveRecord::RecordNotUnique => e
      error_msg="A required field is missing." if e.class == ActiveRecord::StatementInvalid
      error_msg="Username #{fields[:username]} already exists." if e.class == ActiveRecord::RecordNotUnique
      retval[:exception] = e
      retval[:error_msg] = error_msg
    end

    # we return a hash so we can in the future return error messages or other supplemental
    # info back with the new user record
    retval[:user] =user
    retval
  end

  def self.get_validated_user(username, password)
    if username.nil? || username.empty? || password.nil? || password.empty? then
      raise LT::ParameterMissing, "Either username or password is missing"
    end
    user = User.find_by_username(username)
    if user.nil?
      return {:error_msg=>"User not found: #{username}", :exception => LT::UserNotFound.new}
    else 
      if user.password_digest.nil? || !user.authenticate(password) then
        return {:error_msg=>"Password invalid for user: #{username}", :exception => LT::PasswordInvalid.new}
      else
        return {:user=>user}
      end
    end
  end # GetValidatedUser

end # class User
