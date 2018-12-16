
  get '/users/:username/status' do
    role = ""
   status = ""
   puts request.env["HTTP_AUTHORIZATION"]
    decoded_token = JWT.decode(request.env["HTTP_AUTHORIZATION"], SECRET)

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


post '/users/:username/status' do
    role = ""
    status = ""
    puts request.env["HTTP_AUTHORIZATION"]
    decoded_token = JWT.decode(request.env["HTTP_AUTHORIZATION"], SECRET)

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

            new_status_body = JSON.parse(request.body.read)
            puts new_status_body
            new_status = new_status_body['status']
            puts new_status

            puts @user_for_status   
            user_for_status_2 = User.find_by_username(username_for_status).update_column(:status, new_status)
            #user_for_status_2.update_attribute(:status, new_status)

            return 200, "User status updated"
        else 
            msg="unregistered user"
            return 409, msg.to_json
        end

    else
        msg="Admin token required"
        return 401, msg.to_json
    end
end
