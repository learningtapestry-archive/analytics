#!/usr/bin/env ruby

# Copyright 2014 Learntaculous (Hoekstra/Midgley) - All Rights Reserved

# Unauthorized copying of this file, via any medium is strictly prohibited
# Proprietary and confidential

# This script is designed to move user events, in the form of HTML blocks, from
# Redis temporary queue into a Postgres database-backed queue.  Redis will have
# one queue per customer and move it into the Postgres database that 
# corresponds with that customer.  This script is intended to be called by a 
# cron job.

CONFIG_FILE = "config.json"

require 'json'
require 'pg'
require 'redis'

