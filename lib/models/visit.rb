require 'chronic_duration'

#
# Records a page visited by a user
#
class Visit < ActiveRecord::Base
  belongs_to :user
  has_one :profile, through: :user

  has_one :site, through: :page

  belongs_to :page
  delegate :url, :display_name, to: :page

  def time_active=(value)
    self[:time_active] = ChronicDuration.parse(value).to_i
  end
end
