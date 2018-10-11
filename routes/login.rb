post "/login" do
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
		return 409, msg.to_json
	end
  end

