
  get '/users/:username/update' do
    role = ""
   status = ""
   puts request.env["HTTP_TOKEN"]
    decoded_token = JWT.decode(request.env["HTTP_TOKEN"], SECRET)

    decoded = decoded_token.to_json

    parsed = JSON.parse (decoded)

    decoded_username = parsed[0]['username']
    username_for_status = "#{params[:username]}"
    puts "decoded user : " + decoded_username.to_s    
    puts "user for status : " + username_for_status.to_s


    @user = User.find_by_username( decoded_username )
    puts "token user decoded"
    #puts @user['username']

    if @user['role'] == "admin"

        @user_for_status = User.find_by_username( username_for_status ) 

        if @user_for_status
            #@user_for_status.to_json   
            return 200, @user_for_status['status']
        else 
            msg="unregistered user"
            return 404, msg.to_json
        end

    else
        msg="Admin token required"
        return 401, msg.to_json
    end
end


post '/users/:username/update' do
    role = ""
    status = ""
    puts request.env["HTTP_TOKEN"]
    decoded_token = JWT.decode(request.env["HTTP_TOKEN"], SECRET)

    decoded = decoded_token.to_json

    parsed = JSON.parse (decoded)

    decoded_username = parsed[0]['username']
    username_for_status = "#{params[:username]}"
    username_for_update = "#{params[:username]}"
    puts "decoded user : " + decoded_username.to_s    
    puts "user for status : " + username_for_status.to_s


    @user = User.find_by_username( decoded_username )
    puts "token user decoded"
    #puts @user['username']

    if @user['role'] == "admin"

        @user_for_status = User.find_by_username( username_for_status ) 

        if @user_for_status

            new_status_body = JSON.parse(request.body.read)
            puts new_status_body
            new_status = new_status_body['status']
            puts new_status

            puts @user_for_status   
            user_for_status_2 = User.find_by_username(username_for_status).update_column(:status, new_status)
            #user_for_status_2.update_attribute(:status, new_status)

            return 200, "User status updated"
        end
    else 
        @user_for_update = User.find_by_username( username_for_status ) 
        if @user_for_update
            new_body = JSON.parse(request.body.read)
            puts new_body
            new_status = new_body['status']
            new_role = new_body['role']
            new_password = new_body['password']
            new_email = new_body['email']
            puts new_status
            puts new_role
            puts new_password
            puts new_email
            puts @user_for_update   
            user_for_update_2 = User.find_by_username(username_for_update).update_column(:status, new_status)
            user_for_update_3 = User.find_by_username(username_for_update).update_column(:role, new_role)
            user_for_update_4 = User.find_by_username(username_for_update).update_column(:password, new_password)
            user_for_update_5 = User.find_by_username(username_for_update).update_column(:email, new_email)
            return 200, "User info updated"
        else 
            msg="unregistered user"
            return 409, msg.to_json
        end                               
    end
end


