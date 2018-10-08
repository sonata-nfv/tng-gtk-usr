require 'pg'
require 'rubygems'
require 'sinatra'
require 'json'
require 'jwt'

require_relative 'routes/login'
require_relative 'routes/users'
require_relative 'routes/role'
require_relative 'routes/status'

DB_PARAMS = {
  host: 'son-postgres',
#  host: '172.18.0.2',
  dbname: 'gatekeeper',
  user: 'sonatatest',
  password: 'sonata'
}


SECRET = 'my_secret' 


  get '/' do
	erb :init
  end

  get '/users_management' do
	erb :users
  end
