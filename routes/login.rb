post "/login" do
  body = request.body.read
  return 400, {error: "User name and password are required parameters"}.to_json if body.empty?
  params=JSON.parse(body, symbolize_names: true)
  return 400, {error: "User name is required"}.to_json unless (params.key?(:username) && !params[:username].empty?)
  return 400, {error: "Passord is required"}.to_json unless (params.key?(:password) && !params[:password].empty?)
	
	user = User.find_by(username:params[:username]).as_json
  STDERR.puts "user=#{user}"
  STDERR.puts "#{user[:password]}|#{Digest::SHA1.hexdigest(params[:password])}"
	return 404, {error: "Wrong user or password"}.to_json unless user
	return 403, {error: "Unauthorized, wrong user or password"}.to_json unless user[:password] == Digest::SHA1.hexdigest(params[:password])
	t_now = Time.now			
	payload = { username: user[:username], name: user[:name], role: user[:role], email: user[:email], login_time: t_now, expiration_time: t_now + 3600}
	return 200, {token: JWT.encode(payload, SECRET,'HS256')}.to_json
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
