get '/endpoints' do
    @roles = Permission.all
    @roles.to_json
end

delete '/endpoints' do
    puts request.env["HTTP_AUTHORIZATION"]
    decoded_token = JWT.decode(request.env["HTTP_AUTHORIZATION"], SECRET)
    decoded = decoded_token.to_json
    parsed = JSON.parse (decoded)

    decoded_username = parsed[0]['username']    

    puts "decoded user : " + decoded_username.to_s        


    @user = User.find_by_username( decoded_username )
    puts "token user decoded"


    if @user['role'] == "admin"

        puts "Admin token verified"

        new_endpoint_body = JSON.parse(request.body.read)
        puts new_endpoint_body
        new_endpoint_role = new_endpoint_body['role']
        puts new_endpoint_role
        new_endpoint_endpoint = new_endpoint_body['endpoint']
        puts new_endpoint_endpoint
        new_endpoint_verbs = new_endpoint_body['verbs']
        puts new_endpoint_verbs               
        
        #@post = Permission.new( new_endpoint_body )
        @post = Permission.find_by( role: new_endpoint_role, endpoint: new_endpoint_endpoint, verbs: new_endpoint_verbs )
        #puts @post.to_json

        if @post
            @post = Permission.find_by( role: new_endpoint_role, endpoint: new_endpoint_endpoint, verbs: new_endpoint_verbs )                        
            
            Permission.where(role: new_endpoint_role, endpoint: new_endpoint_endpoint, verbs: new_endpoint_verbs).delete_all
            
            msg = {"Success:"=>"Endpoint Deleted"}
            json_output = JSON.pretty_generate (msg)
            puts json_output				
            return 200, json_output   
        else
            msg = {"Error:"=>"Wrong endpoint values"}
            json_output = JSON.pretty_generate (msg)
            puts json_output				
            return 409, json_output             
        end

    else
        msg = {"Error:"=>"Admin token required"}
        json_output = JSON.pretty_generate (msg)
        puts json_output				
        return 401, json_output         
    end
end


post '/endpoints' do
    puts request.env["HTTP_AUTHORIZATION"]
    decoded_token = JWT.decode(request.env["HTTP_AUTHORIZATION"], SECRET)
    decoded = decoded_token.to_json
    parsed = JSON.parse (decoded)

    decoded_username = parsed[0]['username']    

    puts "decoded user : " + decoded_username.to_s        


    @user = User.find_by_username( decoded_username )
    puts "token user decoded"


    if @user['role'] == "admin"

        puts "admin token verified"

        new_endpoint_body = JSON.parse(request.body.read)
        puts new_endpoint_body
        new_endpoint_role = new_endpoint_body['role']
        puts new_endpoint_role
        new_endpoint_endpoint = new_endpoint_body['endpoint']
        puts new_endpoint_endpoint
        new_endpoint_verbs = new_endpoint_body['verbs']
        puts new_endpoint_verbs               
        
        #@endpoint_exists = Permission.find_by_endpoint( new_endpoint_body['endpoint'] )
        @endpoint_exists = Permission.find_by( endpoint: new_endpoint_body['endpoint'] , verbs: new_endpoint_body['verbs']  )
        

        if @endpoint_exists
            msg = {"Error:"=>"Endpoint already exits"}
            json_output = JSON.pretty_generate (msg)
            puts json_output				
            return 409, json_output
        end

        @post = Permission.new( new_endpoint_body )

        @role_exists = Role.find_by_role( new_endpoint_body['role'] ) 

        if @role_exists
        #if (new_endpoint_role == 'admin') || (new_endpoint_role == 'developer') || (new_endpoint_role == 'customer')
            @post.save    
            msg = {"Success:"=>"New Endpoint Registered"}
            json_output = JSON.pretty_generate (msg)
            puts json_output				
            return 200, json_output             
        else
            msg = {"Error:"=>"Role does not exists"}
            json_output = JSON.pretty_generate (msg)
            puts json_output				
            return 409, json_output             
        end

    else
        msg = {"Error:"=>"Admin token required"}
        json_output = JSON.pretty_generate (msg)
        puts json_output				
        return 401, json_output         
    end
end


get '/endpoints/:username' do

    puts request.env["HTTP_AUTHORIZATION"]
    decoded_token = JWT.decode(request.env["HTTP_AUTHORIZATION"], SECRET)

    decoded = decoded_token.to_json

    parsed = JSON.parse (decoded)

    decoded_username = parsed[0]['username']
    username_for_endpoints = "#{params[:username]}"
    puts "decoded user : " + decoded_username.to_s    
    puts "user for endpoints : " + username_for_endpoints.to_s


    @user = User.find_by_username( decoded_username )
    puts "token user decoded"
    #puts @user['username']

    if @user['role'] == "admin"

        @user_for_endpoints = User.find_by_username( username_for_endpoints ) 

        if @user_for_endpoints

            puts @user_for_endpoints['role']
            role = @user_for_endpoints['role']

            #@endpoints = Permission.where(role: role )
            #@endpoints = Permission.where(role: role ).select("endpoint").all
            @endpoints = Permission.where(role: role ).select("endpoint", "verbs").all

            @endpoints.to_json

        else 
            msg = {"Error:"=>"Ungeristered User"}
            json_output = JSON.pretty_generate (msg)
            puts json_output				
            return 404, json_output         
        end

    else
        msg = {"Error:"=>"Admin token required"}
        json_output = JSON.pretty_generate (msg)
        puts json_output				
        return 401, json_output         
    end
end



post '/endpoints-validate' do
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

        role = @user['role']
        @endpoints = Permission.where(role: role ).select("endpoint", "verbs").all
        return 200, @endpoints.to_json

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
