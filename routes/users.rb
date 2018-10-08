get '/users' do
    all = ""
    psql = PG::Connection.new(DB_PARAMS)
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

  get '/users/:email' do
	role = ""
	puts "this is the email"
	puts "#{params[:email]}"
	

    psql = PG::Connection.new(DB_PARAMS)
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

  post '/users' do
	puts "#{params[:name]}"
	puts "#{params[:email]}"
	puts "#{params[:password]}"
	puts "#{params[:role]}"
        puts "#{params[:status]}"

    old_role = ""
   puts "#{params[:email]}"
    psql = PG::Connection.new(DB_PARAMS)
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

      psql = PG::Connection.new(DB_PARAMS)
      psql.exec( "SELECT ROLE FROM USERS WHERE EMAIL='#{params[:email]}'" ) do |result|
        result.each do |row|
        puts " %s " %
        role =  row.to_json
        role = row.to_s
    end
  end
      if role.include? "admin"
          puts role	

          new_password_body = JSON.parse(request.body.read)
          puts new_password_body
          new_password = new_password_body['password']
          puts new_password

          psql = PG::Connection.new(DB_PARAMS)
          psql.exec( "UPDATE USERS SET PASSWORD = '#{new_password}' WHERE EMAIL='#{email_for_password}'" ) 
          msg="User password updated"
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

    email_for_roles = "#{params[:email]}"
    puts email
    puts email_for_roles

  params[:email] = email
     puts #{params[:email]}

      psql = PG::Connection.new(DB_PARAMS)
      psql.exec( "SELECT ENDPOINT FROM ROLES WHERE ROLE IN (SELECT ROLE FROM USERS WHERE EMAIL='#{email_for_roles}')" ) do |result|
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



