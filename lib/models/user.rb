require 'json'

class User < ActiveRecord::Base
  has_secure_password validations: false

  has_many :visits
  has_many :visualizations

  has_one :profile
  accepts_nested_attributes_for :profile

  has_many :emails
  accepts_nested_attributes_for :emails

  belongs_to :organization
  belongs_to :school

  has_many :section_user
  has_many :sections, through: :section_user

  def email
    emails.find_by(primary: true)
  end

  def full_name
    "#{first_name} #{middle_name} #{last_name}".gsub(/\s\s+/," ").strip
  end

  #
  # TODO: Consider migrating to active_model_serializers.
  #
  def as_json(options = {})
    original = super(options)
    original.delete('id')
    original
  end

  def self.summary
    select(:id, :first_name, :last_name, :username).order(:username)
  end
end
