
  get '/users/:email/status' do
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

      psql = PG::Connection.new(DB_PARAMS)
      psql.exec( "SELECT STATUS FROM USERS WHERE EMAIL='#{email_for_status}'" ) do |result|
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

          new_status_body = JSON.parse(request.body.read)
          puts new_status_body
          new_status = new_status_body['status']
          puts new_status

          if (new_status == "active") || (new_status == "cancelled") || (new_status == "suspended")
              puts "the new status is correct"
              puts new_status
              psql = PG::Connection.new(DB_PARAMS)
              psql.exec( "UPDATE USERS SET STATUS = '#{new_status}' WHERE EMAIL='#{email_for_status}'" ) 
              msg="User status updated to " + new_status
              msg.to_json
          else
              msg="Invalid status. It only can be active, suspended or cancelled"	
              msg.to_json				
          end






      else
          msg="the provided token is not from an admin user"
          msg.to_json
  end	
end
