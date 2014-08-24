#!/usr/bin/env ruby

# Copyright 2014 Learntaculous (Hoekstra/Midgley) - All Rights Reserved

# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential

# TODO:
# This appears to be the reddis configuration
# Move this configurator class into Module LT somewhere (LT::Redis?)
# Update dependencies
class Configuration

	# TODO/INPUT:
	# SM: Avoid class instance variables whenever possible. 
	# Try to hold state outside of classes when you can
	# @error_message in particular seems like it should be solved stateless
	# @is_initialized would make more sense (to me) if caller & init were multi-threaded
	@is_initialized = false # this will remain false until config loaded successfully
	@error_message = ""

	def initialize(config_file)
		# Read configuration from file, store in config variable (hash)
		config = JSON.parse(File.read(config_file))

		# If configuration doesn't parse or doesn't contain first element, stop and throw error
		if !config || !config["configuration"] then
			@error_message = "Configuration file '#{config_file}' not found or invalid format."
		else
			begin
				@redis_url = config["configuration"]["redis_url"]
				@redis_queue_name = config["configuration"]["redis_queue_name"]
				@message_error_dir = config["configuration"]["message_error_dir"]
				@message_dberror_dir = config["configuration"]["message_dberror_dir"]

				# Ensure error directories exist, error out if no, normalize paths if so
				if File.directory?(@message_error_dir) && File.directory?(@message_dberror_dir) then
					@message_error_dir = File.expand_path(@message_error_dir)
					@message_dberror_dir = File.expand_path(@message_dberror_dir)

					@is_initialized = true
				else
					@error_message = "Message error directories do not exist, error dir: #{@message_error_dir} and db error dir: #{@message_dberror_dir}"
				end
				
			rescue Exception => e
				@error_message = e.message
			end
		end
	end

	def redis_url
		@redis_url
	end

	def redis_queue_name
		@redis_queue_name
	end

	def message_error_dir
		@message_error_dir
	end

	def message_dberror_dir
		@message_dberror_dir
	end

	def error_message
		@error_message
	end

	def is_initialized
		@is_initialized
	end
end
