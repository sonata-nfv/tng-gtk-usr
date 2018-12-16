    get '/users' do
        @users = User.all
        @users.to_json     
    end

    get '/users/:username' do
        @user = User.find_by_username(params[:username])
        @user.to_json
    end

    post '/users' do

        new_user_body = JSON.parse(request.body.read)
    
        @username = new_user_body['username']
        @name = new_user_body['name']
        @password = new_user_body['password']
        @email = new_user_body['email']
        @role = new_user_body['role']
        #@status = new_user_body['status']

        
        pwd = Digest::SHA1.hexdigest @password.to_s
        puts "this is the login encrypted password"
        puts pwd   
        puts " "

    
        puts @username
        puts @name
        puts @password
        puts @email
        puts @role
        #puts @status

        puts "validating mail"            
        validator =  EmailValidator.valid?(new_user_body['email'])
        if validator
            puts "valid email"
            puts "vvvvv"
        else
            puts "invalid email"
            msg="Invalid email"
            return 409, msg.to_json
        end
        puts "validating mail"

        #new_user_body = JSON.parse(request.body.read)
        @post = User.new( new_user_body )

        @post['password'] = pwd

        puts "password from object"
        puts @post['password']
        puts @post['status']
        @post['status'] = "active"
        puts @post['status']
        #return @post.to_json
    
        @exist = User.find_by_username(new_user_body['username'])
        if !@exist
            @post.save    
            #return 200, 'New User registered'   
            return 200, @post.to_json 
        else
            return 409, 'User already exist'
        end
      end


  post '/users/old' do

    new_user_body = JSON.parse(request.body.read)

    @username = new_user_body['username']
    @name = new_user_body['name']
    @password = new_user_body['password']
    @email = new_user_body['email']
    @role = new_user_body['role']
    @status = new_user_body['status']

    puts @username
    puts @name
    puts @password
    puts @email
    puts @role
    puts @status

    
    #new_user_body = JSON.parse(request.body.read)
    @post = User.new( new_user_body )

    @exist = User.find_by_username(new_user_body['username'])
    if !@exist
        @post.save    
        return 200, 'New User registered'   
    else
        return 409, 'User already exist'
    end


  end




post '/users/:username/password' do
    role = ""
    status = ""
    puts request.env["HTTP_AUTHORIZATION"]
    decoded_token = JWT.decode(request.env["HTTP_AUTHORIZATION"], SECRET)

    decoded = decoded_token.to_json

    parsed = JSON.parse (decoded)

    decoded_username = parsed[0]['username']
    username_for_password = "#{params[:username]}"
    puts "decoded user : " + decoded_username.to_s    
    puts "user for password : " + username_for_password.to_s


    @user = User.find_by_username( decoded_username )
    puts "token user decoded"
    #puts @user['username']

    if @user['role'] == "admin"

        @user_for_password = User.find_by_username( username_for_password ) 

        if @user_for_password



            new_password_body = JSON.parse(request.body.read)
            puts new_password_body
            new_password = new_password_body['password']
            puts new_password

            new_password_encrypted = Digest::SHA1.hexdigest new_password
            puts "new password encrypted"
            puts new_password_encrypted

            luis = Digest::SHA1.hexdigest 'luis'
            puts "luis encrypted"
            puts luis



            
            @user_for_password.update_attribute(:password, new_password_encrypted)
            return 200, "User password updated"
        else 
            msg="Unregistered user"
            return 409, msg.to_json
        end

    else
        msg="Admin token required"
        return 401, msg.to_json
    end
end


get '/users/:username/endpoints' do

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

            #@endpoints = Role.where(role: role )
            @endpoints = Role.where(role: role ).select("endpoint").all

            @endpoints.to_json

        else 
            msg="Unregistered user"
            return 404, msg.to_json
        end

    else
        msg="Admin token required"
        return 401, msg.to_json
    end
end


delete '/users' do
    @users = User.destroy_all
    msg = "All users deleted"
    return 200, msg.to_json
    #@users.to_json     
end
