
  get '/users/:username/update' do
    #
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
            msg = {"error:"=>"Unregistered user"}
            json_output = JSON.pretty_generate (msg)
            puts json_output				
            return 404, json_output            
        end

    else
        msg = {"error:"=>"Admin token required"}
        json_output = JSON.pretty_generate (msg)
        puts json_output				
        return 401, json_output                
    end
end


post '/users/:username/update' do
    role = ""
    status = ""
    puts request.env["HTTP_AUTHORIZATION"]
    decoded_token = JWT.decode(request.env["HTTP_AUTHORIZATION"], SECRET)

    decoded = decoded_token.to_json

    parsed = JSON.parse (decoded)

    decoded_username = parsed[0]['username']
    username_for_status = "#{params[:username]}"
    username_for_update = "#{params[:username]}"
    puts "decoded user : " + decoded_username.to_s    
    puts "user for status : " + username_for_status.to_s


    @user = User.find_by_username( decoded_username )
    puts "token user decoded"
    
	if !@user
		msg = {"error:"=>"Wrong user"}
		json_output = JSON.pretty_generate (msg)
		puts json_output				
		return 404, json_output
    end
    
    if @user['role'] == "admin"

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
            new_password_encrypted = Digest::SHA1.hexdigest new_password
            puts "new password encrypted"
            puts new_password_encrypted            

            puts new_email
            puts @user_for_update   

            user_for_update_2 = User.find_by_username(username_for_update).update_column(:status, new_status)
            user_for_update_3 = User.find_by_username(username_for_update).update_column(:role, new_role)
            user_for_update_4 = User.find_by_username(username_for_update).update_column(:password, new_password_encrypted)
            user_for_update_5 = User.find_by_username(username_for_update).update_column(:email, new_email)

            msg = {"Sucess:"=>"User info updated"}
            json_output = JSON.pretty_generate (msg)
            puts json_output                 
            return 200, json_output
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
            user_for_update_5 = User.find_by_username(username_for_update).update_column(:email, new_email)

            if new_role == "admin"  
                msg = {"Error:"=>"This user cannot select the admin role"}
                json_output = JSON.pretty_generate (msg)
                puts json_output                 
                return 409 , json_output
            else
                user_for_update_3 = User.find_by_username(username_for_update).update_column(:role, new_role)
            end    

            if new_password == ""
                msg = {"Error:"=>"This user cannot let the password empty"}
                json_output = JSON.pretty_generate (msg)
                puts json_output                 
                return 409 , json_output                
            else
                puts new_password
                new_password_encrypted = Digest::SHA1.hexdigest new_password
                puts "new password encrypted"
                puts new_password_encrypted  
                user_for_update_4 = User.find_by_username(username_for_update).update_column(:password, new_password_encrypted) 
            end    

            msg = {"Sucess:"=>"User info updated"}
            json_output = JSON.pretty_generate (msg)
            puts json_output                 
            return 200 , json_output                                            
            
        else 
            msg = {"Error:"=>"Unregistered user"}
            json_output = JSON.pretty_generate (msg)
            puts json_output                 
            return 409 , json_output                    
        end                               
    end
end


patch '/users/:username' do
    role = ""
    status = ""
    puts request.env["HTTP_AUTHORIZATION"]
    decoded_token = JWT.decode(request.env["HTTP_AUTHORIZATION"], SECRET)

    decoded = decoded_token.to_json
    puts "this is the decoded token"
    puts decoded_token
    puts "this is the decoded token"

    #parsed = JSON.parse (decoded)
    parsed = JSON.parse (decoded_token.to_json)

    decoded_username = parsed[0]['username']
    username_for_status = "#{params[:username]}"
    username_for_update = "#{params[:username]}"
    puts "decoded user : " + decoded_username.to_s    
    puts "user for status : " + username_for_status.to_s


    @user = User.find_by_username( decoded_username )
    puts "token user decoded"
    #puts @user['username']

    if @user['role'] == "admin"

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
            new_password_encrypted = Digest::SHA1.hexdigest new_password
            puts "new password encrypted"
            puts new_password_encrypted            

            puts new_email
            puts @user_for_update   


            puts "validating mail"            
            validator =  EmailValidator.valid?(new_email)
            if validator
                puts "valid email"
                puts "vvvvv"
            else
                puts "invalid email"
                msg="Invalid email"
                return 409, msg.to_json
            end
            puts "validating mail"


            user_for_update_2 = User.find_by_username(username_for_update).update_column(:status, new_status)
            user_for_update_3 = User.find_by_username(username_for_update).update_column(:role, new_role)
            user_for_update_4 = User.find_by_username(username_for_update).update_column(:password, new_password_encrypted)
            user_for_update_5 = User.find_by_username(username_for_update).update_column(:email, new_email)

            return 200, "User info updated"
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
            #new_password_encrypted = Digest::SHA1.hexdigest new_password
            #puts "new password encrypted"
            #puts new_password_encrypted            

            puts new_email
            puts @user_for_update   

            puts "validating mail"            
            validator =  EmailValidator.valid?(new_email)
            if validator
                puts "valid email"
                puts "vvvvv"
            else
                puts "invalid email"
                msg="Invalid email"
                return 409, msg.to_json
            end
            puts "validating mail"


            user_for_update_2 = User.find_by_username(username_for_update).update_column(:status, new_status)
            #user_for_update_3 = User.find_by_username(username_for_update).update_column(:role, new_role)
            #user_for_update_4 = User.find_by_username(username_for_update).update_column(:password, new_password_encrypted)
 
            user_for_update_5 = User.find_by_username(username_for_update).update_column(:email, new_email)

            if new_role == "admin"  
                msg="This user cannot select the admin role"
                return 409, msg.to_json
            else
                user_for_update_3 = User.find_by_username(username_for_update).update_column(:role, new_role)
            end    

            if new_password == ""
                msg="This user cannot let the password empty"
                return 409, msg.to_json
            else
                puts new_password
                new_password_encrypted = Digest::SHA1.hexdigest new_password
                puts "new password encrypted"
                puts new_password_encrypted  
                user_for_update_4 = User.find_by_username(username_for_update).update_column(:password, new_password_encrypted) 
            end    


            return 200, "User info updated"
        else 
            msg="unregistered user"
            return 409, msg.to_json
        end                               
    end
end

