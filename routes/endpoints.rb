get '/endpoints' do
    @roles = Role.all
    @roles.to_json
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