require 'json'
class User < ActiveRecord::Base

  def password=(password)
    self.password_salt = BCrypt::Engine.generate_salt
    self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
  end

  def password_matches?(password)
    retval = false
    if self.password_hash == BCrypt::Engine.hash_secret(password, self.password_salt) then
      retval = true
    end
    retval
  end

  def self.create_user_from_json(json_str)
    json = JSON.parse(json_str)
    fields = {}
    fields[:password] = json.fetch('password')
    fields[:first_name] = json['first_name']
    fields[:last_name] = json['last_name']
    fields[:username] = json['username']
    self.create_user(fields)
  end

  def self.create_user(fields)
    fields.fetch(:password)
    user = User.new(fields)
    user.save!
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
