require 'pg'
require 'rubygems'
require 'sinatra'
require 'json'
require 'jwt'
require 'sinatra/activerecord'
require 'rake'
require 'bcrypt'
require 'digest/sha1'

require_relative 'routes/login'
require_relative 'routes/users'
require_relative 'routes/role'
require_relative 'routes/status'
#require_relative 'routes/endpoints'

DB_PARAMS = {
#  host: 'son-postgres',
  host: '172.18.0.2',
  dbname: 'gatekeeper',
  user: 'sonatatest',
  password: 'sonata'
}


SECRET = 'my_secret' 

class YourApplication < Sinatra::Base
  register Sinatra::ActiveRecordExtension
end

class User < ActiveRecord::Base
  validates_presence_of :name
end

class Role < ActiveRecord::Base
  validates_presence_of :role
end


configure :development do
  set :database, {adapter: 'postgresql',  encoding: 'unicode', database: 'gatekeeper', pool: 2, username: 'sonatatest', password: 'sonata', host: 'son-postgres'}
end

configure :production do
  set :database, {adapter: 'postgresql',  encoding: 'unicode', database: 'gatekeeper', pool: 2, username: 'sonatatest', password: 'sonata', host: 'son-postgres'}
end


  get '/' do
	erb :init
  end

  get '/users_management' do
	erb :users
  end
