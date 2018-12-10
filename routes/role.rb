    get '/api/v3/roles' do
        @roles = Role.all
        @roles.to_json      
    end

    get '/api/v3/users/:username/role' do
        role = ""

        puts request.env["HTTP_TOKEN"]
        decoded_token = JWT.decode(request.env["HTTP_TOKEN"], SECRET)

        decoded = decoded_token.to_json

        parsed = JSON.parse (decoded)

        decoded_username = parsed[0]['username']
        username_for_role = "#{params[:username]}"
        puts "decoded user : " + decoded_username.to_s    
        puts "user for role : " + username_for_role.to_s


        @user = User.find_by_username( decoded_username )
        puts "token user decoded"
        #puts @user['username']

        if @user['role'] == "admin"

            @user_for_role = User.find_by_username( username_for_role ) 

            if @user_for_role  
                return 200, @user_for_role['role']
            else 
                msg="unregistered user"
                return 404, msg.to_json
            end

        else
            msg="Admin token required"
            return 404, msg.to_json
        end
    end


    post '/api/v3/users/:username/role' do
        role = ""

        puts request.env["HTTP_TOKEN"]
        decoded_token = JWT.decode(request.env["HTTP_TOKEN"], SECRET)

        decoded = decoded_token.to_json

        parsed = JSON.parse (decoded)

        decoded_username = parsed[0]['username']
        username_for_role = "#{params[:username]}"
        puts "decoded user : " + decoded_username.to_s    
        puts "user for role : " + username_for_role.to_s


        @user = User.find_by_username( decoded_username )
        puts "token user decoded"
        #puts @user['username']

        if @user['role'] == "admin"

            @user_for_role = User.find_by_username( username_for_role ) 

            if @user_for_role

                new_role_body = JSON.parse(request.body.read)
                puts new_role_body
                new_role = new_role_body['role']
                puts new_role
    
                @user_for_role.update_attribute(:role, new_role)
                return 200, "User role updated"
            else 
                msg="Unregistered user"
                return 404, msg.to_json
            end

        else
            msg="Admin token required"
            return 404, msg.to_json
        end
    end

