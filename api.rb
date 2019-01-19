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
require 'composite_primary_keys'

require_relative 'routes/login'
require_relative 'routes/users'
require_relative 'routes/role'
require_relative 'routes/status'
#require_relative 'routes/endpoints'
require_relative 'routes/permissions'
require_relative 'routes/update'
require_relative 'routes/roles'

DB_PARAMS = {
#  host: 'son-postgres',
  host: '172.18.0.2',
  dbname: 'gatekeeper',
  user: 'sonatatest',
  password: 'sonata'
}


SECRET = 'my_secret' 

=begin
class YourApplication < Sinatra::Base
  register Sinatra::ActiveRecordExtension
end

class User < ActiveRecord::Base
  validates_presence_of :name
end

class Role < ActiveRecord::Base
  validates_presence_of :role
end

class Permission < ActiveRecord::Base
  validates_presence_of :role
end
=end
#configure :development do
#  set :database, {adapter: 'postgresql',  encoding: 'unicode', database: 'gatekeeper', pool: 2, username: 'sonatatest', password: 'sonata', host: 'son-postgres'}
#end

#configure :production do
#  set :database, {adapter: 'postgresql',  encoding: 'unicode', database: 'gatekeeper', pool: 2, username: 'sonatatest', password: 'sonata', host: 'son-postgres'}
#end

