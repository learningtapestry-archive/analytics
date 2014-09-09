require 'json'
require './lib/lt_base.rb'

class User < ActiveRecord::Base

  def self.CreateUserFromJson(json)
    if json.nil? || json.empty? then
      raise LT::ParameterMissing, "JSON is either nil or empty"
    else
      begin
        parsed_json = JSON.parse(json)

        # Ensure at minimum username and password is present in JSON
        if !parsed_json.has_key?('username') || !parsed_json.has_key?('password') then
          raise LT::InvalidParameter, "Username or password not present in JSON."
        else
          # Parse out JSON into variables
          username = parsed_json['username']
          password = parsed_json['password']
          first_name = parsed_json['first_name'] unless !parsed_json.has_key?('first_name')
          last_name = parsed_json['last_name'] unless !parsed_json.has_key?('last_name')

          # Return back the newly created user
          return CreateUser(username, password, first_name, last_name)
        end
      rescue Exception => e
        raise LT::InvalidParameter, "Invalid JSON: " + e.message
      end
    end
  end

  def self.CreateUser(username, password, first_name = "", last_name = "")

    if username.nil? || username.empty? || password.nil? || password.empty? then
      raise LT::ParameterMissing, "Username or password is not provided"
    else
      # Use AR to save user
      user = User.new
      user.username = username
      user.password = Digest::MD5.hexdigest(password)
      user.first_name = first_name
      user.last_name = last_name
      user.save

      return user
    end
  end

  def self.ValidateUser(username, password)
    if username.nil? || username.empty? || password.nil? || password.empty? then
      raise LT::ParameterMissing, "Either username or password is missing"
    else
      user = User.where(username: username).first
      if user.nil?
        raise LT::UserNotFound, "Username not found: " + username
      else 
        if Digest::MD5.hexdigest(password) != user.password then
          raise LT::PasswordInvalid, "Password invalid, user: " + username
        else
          return user
        end
      end
    end
  end

end
