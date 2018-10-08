post "/login" do
	role = ""
	puts "#{params[:email]}"
	puts "#{params[:password]}"

    psql = PG::Connection.new(DB_PARAMS)
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

