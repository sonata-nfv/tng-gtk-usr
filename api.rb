require 'pg'
require 'rubygems'
require 'sinatra'
require 'json'
require 'jwt'

db_params = {
#  host: 'son-postgres',
  host: 'localhost',
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

  post '/register' do
	puts "#{params[:name]}"
	puts "#{params[:email]}"
	puts "#{params[:password]}"
	puts "#{params[:role]}"

    old_role = ""
   puts "#{params[:email]}"
    psql = PG::Connection.new(db_params)
    psql.exec( "SELECT ROLE FROM USERS WHERE EMAIL='#{params[:email]}'" ) do |result|
	  puts "user | email    | role"
	  result.each do |row|
          puts " %s " %
	  old_role = old_role + "" + row.to_json
        end
end
	if old_role != ""
		msg="this user is already registered"
		msg.to_json
	else
		psql.exec( "INSERT INTO USERS (NAME, PASSWORD, EMAIL, ROLE) VALUES ('#{params[:name]}', '#{params[:password]}', '#{params[:email]}', '#{params[:role]}')" )
		msg="user registered"
		msg.to_json


	end

	

	
	
  end



  post '/login' do
	role = ""
	puts "#{params[:email]}"
	puts "#{params[:password]}"

    psql = PG::Connection.new(db_params)
    psql.exec( "SELECT ROLE FROM USERS WHERE EMAIL='#{params[:email]}' AND PASSWORD='#{params[:password]}'" ) do |result|
	  puts "user | email    | role"
	  result.each do |row|
          	puts " %s " %
	  	role = role + "" + row.to_json
        	end
	end
	if role != ""
		#role.to_json

		payload = { email: "#{params[:email]}", exp: Time.now.to_i + 60 * 60, iat: Time.now.to_i}
		token = JWT.encode(payload, SECRET,'HS256')
		token.to_json

	else
		msg="unregistered user"
		msg.to_json
	end
  end



  post '/get_role' do
      role = ""
      puts "#{params[:token]}"
      decoded_token = JWT.decode("#{params[:token]}", SECRET)

      decoded = decoded_token.to_json

      parsed = JSON.parse (decoded)

      email = parsed[0]['email']
      puts email

	params[:email] = email
       puts #{params[:email]}

	    psql = PG::Connection.new(db_params)
	    psql.exec( "SELECT ROLE FROM USERS WHERE EMAIL='#{params[:email]}'" ) do |result|
		  result.each do |row|
	          puts " %s " %
		  role = role + "" + row.to_json
	        end
	end
		if role != ""
                        parsed_role = JSON.parse (role)
			role2 = parsed_role['role']
			role2.to_json
		else
			msg="unregistered user"
			msg.to_json
	end



	
  end



  post '/get_role_endpoint' do
      role = ""
	ep = ""
      puts "#{params[:token]}"
      decoded_token = JWT.decode("#{params[:token]}", SECRET)

      decoded = decoded_token.to_json

      parsed = JSON.parse (decoded)

      email = parsed[0]['email']
      puts email

	params[:email] = email
       puts #{params[:email]}

	    psql = PG::Connection.new(db_params)
	    psql.exec( "SELECT ENDPOINT FROM ROLES WHERE ROLE IN (SELECT ROLE FROM USERS WHERE EMAIL='#{params[:email]}')" ) do |result|
		  result.each do |row|
	          puts "%s" %
		  role = role + row.to_json
	        end
	end
		if role != ""
			role.to_json
		else
			msg="unregistered user"
			msg.to_json
		end



	
  end





get '/get_all' do
  all = ""
  psql = PG::Connection.new(db_params)
 psql.exec( "SELECT * FROM USERS" ) do |result|
  puts "user | email    | role"
  
  result.each do |row|
    puts " %s | %s | %s " %
      row.values_at('name', 'email', 'role')
      all = all + "" + row.to_json
  end
     
  end
    all.to_json
   
end


get '/get_all_roles' do
  all = ""
  psql = PG::Connection.new(db_params)
 psql.exec( "SELECT * FROM ROLES" ) do |result|
  puts "role | endpoint"
  
  result.each do |row|
    puts " %s | %s " %
      row.values_at('role', 'eendpoint')
      all = all + "" + row.to_json
  end
     
  end
    all.to_json
   
end