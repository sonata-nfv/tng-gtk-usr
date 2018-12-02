post "/login" do
	role = ""
	puts "#{params[:username]}"
	puts "#{params[:password]}"


	@user = User.find_by_username(params[:username])

	@typed_password = "#{params[:password]}"

	puts "typed_password"
	puts @typed_password
	pwd = Digest::SHA1.hexdigest @typed_password.to_s
	puts "this is the login encrypted password"
	puts pwd
	#puts "paco encrypted"
	#pwd_2 = Digest::SHA1.hexdigest 'paco'
	#puts pwd_2


	@user['password']


	if pwd == @user['password']	

		t_now = Time.now
		puts t_now
		t_60 = t_now + 3600			

		#payload = { username: "#{params[:username]}", password: @user['email'], exp: Time.now.to_i + 60 * 60, iat: Time.now.to_i}
		payload = { username: "#{params[:username]}", password: @user['email'], login_time: t_now, expiration_time: t_60}
		token = JWT.encode(payload, SECRET,'HS256')

		json_token = JSON.generate("token"=>token )
		puts json_token

        role = @user['role']
		endpoints = Role.where(role: role ).select("endpoint", "verbs").all
		#ep = endpoints.to_json		
		ep = JSON.parse (endpoints.to_json)
		puts ep
		
		json_output = JSON.pretty_generate [{"token"=>token},{"endpoints"=>ep}]
		puts json_output

		t_now = Time.now
		puts t_now
		t_60 = t_now + 3600
		puts t_60


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
		msg="Unregistered user"
		return 404, msg.to_json
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
