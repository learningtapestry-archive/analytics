class Section < ActiveRecord::Base
  has_many :section_user
  has_many :users, through: :section_user

  def display_name
    self.name||self.section
  end

  def teachers
    retval = self.section_user.dup.map do |su|
      if su.user_type == __method__.to_s.singularize.capitalize
        su.user.staff_member
      end
    end
    retval.compact! if retval.respond_to?(:"compact!")
    retval
  end
  def students
    retval = self.section_user.dup.map do |su|
      if su.user_type == __method__.to_s.singularize.capitalize
        su.user.student
      end
    end
    retval.compact! if retval.respond_to?(:"compact!")
    retval
  end
end
