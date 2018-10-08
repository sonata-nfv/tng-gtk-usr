
get '/users/roles/get_all' do
    all = ""
    psql = PG::Connection.new(DB_PARAMS)
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


  get '/users/:email/role' do
    role = ""
    puts "This is the token"	  
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

      psql = PG::Connection.new(DB_PARAMS)
      psql.exec( "SELECT ROLE FROM USERS WHERE EMAIL='#{email_for_role}'" ) do |result|
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


          new_role_body = JSON.parse(request.body.read)
          puts new_role_body
          new_role = new_role_body['role']
          puts new_role

          if (new_role == "admin") || (new_role == "developer") || (new_role == "customer")
              puts "the new role is correct"
              puts new_role
              psql = PG::Connection.new(DB_PARAMS)
              psql.exec( "UPDATE USERS SET ROLE='#{new_role}' WHERE EMAIL='#{email_for_role}'" ) 				
              msg="User role updated to " + new_role
              msg.to_json
          else
              msg="Invalid role. It only can be admin, developer or customer"	
              msg.to_json				
          end



      else
          msg="the provided token is not from an admin user"
          msg.to_json
  end	
end