require 'pg'
require 'rubygems'
require 'sinatra'
require 'json'
require 'jwt'
require 'sinatra/activerecord'
require 'rake'
require 'bcrypt'
require 'digest/sha1'
require 'email_validator'

require_relative 'routes/login'
require_relative 'routes/users'
require_relative 'routes/role'
require_relative 'routes/status'
require_relative 'routes/endpoints'
require_relative 'routes/update'
require_relative 'routes/roles'



tango_profile = Profile.new
tango_profile.role = "admin"
tango_profile.description = "admin role default description"
puts tango_profile.role
tango_profile.save
tango_user = User.new
tango_user.username = "tango"
tango_user.name = "tango"
tango_user.password = "t4ng0"
tango_user.email = "tango@tango.com"
tango_user.role = "admin"
puts tango_user.username
tango_user.save


