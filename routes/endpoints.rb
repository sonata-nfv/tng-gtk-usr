get '/endpoints' do
    @roles = Role.all
    @roles.to_json
end


post '/endpoints' do
    puts request.env["HTTP_TOKEN"]
    decoded_token = JWT.decode(request.env["HTTP_TOKEN"], SECRET)
    decoded = decoded_token.to_json
    parsed = JSON.parse (decoded)

    decoded_username = parsed[0]['username']    

    puts "decoded user : " + decoded_username.to_s        


    @user = User.find_by_username( decoded_username )
    puts "token user decoded"


    if @user['role'] == "admin"

        new_endpoint_body = JSON.parse(request.body.read)
        puts new_endpoint_body
        new_endpoint_role = new_endpoint_body['role']
        puts new_endpoint_role
        new_endpoint_endpoint = new_endpoint_endpoint['endpoint']
        puts new_endpoint_endpoint
        new_endpoint_verbs = new_endpoint_verbs['verbs']
        puts new_endpoint_verbs               
        
        @post = Role.new( new_endpoint_body )

        if (new_endpoint_role == 'admin') || (new_endpoint_role == 'developer') @@ (new_endpoint_role == 'customer')
            @post.save    
            return 200, 'New Endpoint Registered'   
        else
            return 409, 'Wrong role'
        end

    else
        msg="Admin token required"
        return 401, msg.to_json
    end
end


get '/endpoints/:username' do

    puts request.env["HTTP_TOKEN"]
    decoded_token = JWT.decode(request.env["HTTP_TOKEN"], SECRET)

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
        return 404, msg.to_json
    end
end