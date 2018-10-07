require 'pg'
require 'rubygems'
require 'sinatra'
require 'json'
require 'jwt'

db_params = {
#  host: 'son-postgres',
  host: '172.18.0.2',
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

  post '/users' do
	puts "#{params[:name]}"
	puts "#{params[:email]}"
	puts "#{params[:password]}"
	puts "#{params[:role]}"
        puts "#{params[:status]}"

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
		psql.exec( "INSERT INTO USERS (NAME, PASSWORD, EMAIL, ROLE, STATUS) VALUES ('#{params[:name]}', '#{params[:password]}', '#{params[:email]}', '#{params[:role]}', '#{params[:status]}')" )
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

get '/userses/:test' do
	"hola #{params[:test]}"
end


  get '/users/:email' do
	role = ""
	puts "this is the email"
	puts "#{params[:email]}"
	

    psql = PG::Connection.new(db_params)
    psql.exec( "SELECT * FROM USERS WHERE EMAIL='#{params[:email]}'" ) do |result|
	  puts "user | email    | role"
	  result.each do |row|
          	puts " %s " %
		  role = role + "" + row.to_json
		  puts 'cosassss'
        	end
	end
	if role != ""
		role.to_json

	else
		msg="unregistered user for checking"
		msg.to_json
	end
  end



  get '/users/:email/role' do
	  role = ""
	  puts "This is the token"	  
	  puts request.env["HTTP_TOKEN"]
      decoded_token = JWT.decode(request.env["HTTP_TOKEN"], SECRET)

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
		  role = row
	        end
	end
		if role != ""
			return role.to_json
		else
			msg="unregistered user"
			msg.to_json
	end	
  end




  get '/users/:email/status' do
      role = ""
 	status = ""
	 puts request.env["HTTP_TOKEN"]
      decoded_token = JWT.decode(request.env["HTTP_TOKEN"], SECRET)

      decoded = decoded_token.to_json

      parsed = JSON.parse (decoded)

      email = parsed[0]['email']
      puts email

	params[:email] = email
       puts #{params[:email]}

	    psql = PG::Connection.new(db_params)
	    psql.exec( "SELECT STATUS FROM USERS WHERE EMAIL='#{params[:email]}'" ) do |result|
		  result.each do |row|
	          puts " %s " %
		   role =  row.to_json
		   role.to_json
                   status = row
	        end
	end
		if status != ""
			return status.to_json
		else
			msg="unregistered user"
			msg.to_json
	end	
  end


  post '/users/:email/status' do
      role = ""
 	status = ""
	 puts request.env["HTTP_TOKEN"]
      decoded_token = JWT.decode(request.env["HTTP_TOKEN"], SECRET)

      decoded = decoded_token.to_json

      parsed = JSON.parse (decoded)

      email = parsed[0]['email']
      email_for_status = "#{params[:email]}"
      puts email
      puts email_for_status

	params[:email] = email
       puts #{params[:email]}
	puts #email_for_status

	    psql = PG::Connection.new(db_params)
	    psql.exec( "SELECT ROLE FROM USERS WHERE EMAIL='#{params[:email]}'" ) do |result|
		  result.each do |row|
	          puts " %s " %
		   role =  row.to_json
                   role = row.to_s
	        end
	end
		if role.include? "admin"
			puts role	

	   	        psql = PG::Connection.new(db_params)
	                psql.exec( "UPDATE USERS SET STATUS = '#{params[:status]}' WHERE EMAIL='#{email_for_status}'" ) 
			msg="User status updated"
			msg.to_json
		else
			msg="the provided token is not from an admin user"
			msg.to_json
	end	
  end




 post '/users/:email/change_user_password' do
      role = ""
 	status = ""
	 puts request.env["HTTP_TOKEN"]
      decoded_token = JWT.decode(request.env["HTTP_TOKEN"], SECRET)

      decoded = decoded_token.to_json

      parsed = JSON.parse (decoded)

      email = parsed[0]['email']
      email_for_password = "#{params[:email]}"
      puts email
      puts email_for_password

	params[:email] = email
       puts #{params[:email]}
	puts #email_for_status

	    psql = PG::Connection.new(db_params)
	    psql.exec( "SELECT ROLE FROM USERS WHERE EMAIL='#{params[:email]}'" ) do |result|
		  result.each do |row|
	          puts " %s " %
		   role =  row.to_json
                   role = row.to_s
	        end
	end
		if role.include? "admin"
			puts role	

	   	        psql = PG::Connection.new(db_params)
	                psql.exec( "UPDATE USERS SET PASSWORD = '#{params[:password]}' WHERE EMAIL='#{email_for_password}'" ) 
			msg="User password updated"
			msg.to_json
		else
			msg="the provided token is not from an admin user"
			msg.to_json
	end	
  end


  post '/users/:email/role' do
      role = ""
 	status = ""
	 puts request.env["HTTP_TOKEN"]
      decoded_token = JWT.decode(request.env["HTTP_TOKEN"], SECRET)

      decoded = decoded_token.to_json

      parsed = JSON.parse (decoded)

      email = parsed[0]['email']
      email_for_role = "#{params[:email]}"
      puts email
      puts email_for_role

	params[:email] = email
       puts #{params[:email]}
	puts #email_for_status

	    psql = PG::Connection.new(db_params)
	    psql.exec( "SELECT ROLE FROM USERS WHERE EMAIL='#{params[:email]}'" ) do |result|
		  result.each do |row|
	          puts " %s " %
		   role =  row.to_json
                   role = row.to_s
	        end
	end
		if role.include? "admin"
			puts role	

	   	        psql = PG::Connection.new(db_params)
	                psql.exec( "UPDATE USERS SET ROLE = '#{params[:role]}' WHERE EMAIL='#{email_for_role}'" ) 
			msg="User role updated"
			msg.to_json
		else
			msg="the provided token is not from an admin user"
			msg.to_json
	end	
  end









  get '/users/:email/get_role_endpoints' do
      role = ""
	ep = ""
	puts request.env["HTTP_TOKEN"]
      decoded_token = JWT.decode(request.env["HTTP_TOKEN"], SECRET)

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





get '/users' do
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


get '/users/roles/get_all' do
  all = ""
  psql = PG::Connection.new(db_params)
 psql.exec( "SELECT * FROM ROLES" ) do |result|
  puts "role | endpoint"
  
  result.each do |row|
    puts " %s | %s " %
      row.values_at('role', 'endpoint')
      all = all + "" + row.to_json
  end
     
  end
    all.to_json
   
end