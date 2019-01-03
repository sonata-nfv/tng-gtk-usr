post "/login" do
	role = ""
	#puts "#{params[:username]}"
	#puts "#{params[:password]}"
	
	login_body= JSON.parse(request.body.read)
	puts login_body['username']
	puts login_body['password']

	@user = User.find_by_username(login_body['username'])
	@typed_password = "#{login_body['password']}"


	if !@user
		msg = {"error:"=>"Wrong user or password"}
		json_output = JSON.pretty_generate (msg)
		puts json_output				
		return 404, json_output
	end

	#@user = User.find_by_username(params[:username])
	#@typed_password = "#{params[:password]}"
	puts "typed_password"
	puts @typed_password
	pwd = Digest::SHA1.hexdigest @typed_password.to_s
	puts "this is the login encrypted password"
	puts pwd
	puts "this is the DDBB encrypted password"
	puts @user['password']

	if pwd == @user['password']	

		t_now = Time.now
		puts t_now
		t_60 = t_now + 3600			
		#payload = { username: "#{params[:username]}", email: @user['email'], login_time: t_now, expiration_time: t_60}

        role = @user['role']
		endpoints = Role.where(role: role ).select("endpoint", "verbs").all

		ep = JSON.parse (endpoints.to_json)
		puts ep


		payload = { username: login_body['username'], email: @user['email'], role: role, endpoints: ep , login_time: t_now, expiration_time: t_60}
		token = JWT.encode(payload, SECRET,'HS256')
		json_token = JSON.generate("token"=>token )
		puts json_token


		decoded_token = JWT.decode(token, SECRET)

		decoded = decoded_token.to_json
		puts "this is the decoded token"
		puts decoded_token
		puts "this is the decoded token"
	
		#parsed = JSON.parse (decoded)
		parsed = JSON.parse (decoded_token.to_json)
		puts parsed



        role = @user['role']
		endpoints = Role.where(role: role ).select("endpoint", "verbs").all

		ep = JSON.parse (endpoints.to_json)
		puts ep
		
		#json_output = JSON.pretty_generate [{"token"=>token},{"endpoints"=>ep}]
		
		text = {"token"=>token, "endpoints"=>ep}
		json_output = JSON.pretty_generate (text)
		puts json_output

		return 200, json_output

	else		
		puts "the pwd is not correct"
		puts pwd
		puts @user['password']
		msg="Unauthorized, wrong user or password"
		return 409, msg.to_json
	end



	if @user
		payload = { username: "#{params[:username]}", exp: Time.now.to_i + 60 * 60, iat: Time.now.to_i}
		token = JWT.encode(payload, SECRET,'HS256')
		return 200, token.to_json
	else
		msg = {"Error:"=>"Unregistered user"}
		json_output = JSON.pretty_generate (msg)
		puts json_output				
		return 404, json_output 	
	end
  end



  delete "/login" do
	redirect '/'
  end



  post "/login/old" do
	role = ""
	puts "#{params[:username]}"
	puts "#{params[:password]}"

	@user = User.find_by_username(params[:username])

	if @user
		payload = { username: "#{params[:username]}", exp: Time.now.to_i + 60 * 60, iat: Time.now.to_i}
		token = JWT.encode(payload, SECRET,'HS256')
		return 200, token.to_json
	else
		msg="Unregistered user"
		return 404, msg.to_json
	end
  end
