    get '/roles' do
        @roles = Profile.all
        return 200, @roles.to_json      
    end

    get '/roles/:role' do
        @role = Profile.find_by_role(params[:role])
        if @role
            return 200, @role.to_json 
        else
            msg = {"Error"=>"Role not found"}
            json_output = JSON.pretty_generate (msg)
            puts json_output				
            return 404, json_output 
        end 
    end    


    post '/roles' do
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
    
            new_role_body = JSON.parse(request.body.read)
            puts new_role_body
            new_role_name = new_role_body['role']
            puts new_role_name   
            new_role_description = new_role_body['description']
            puts new_role_description                        
            
            @post = Profile.new( new_role_body )

            @exist = Profile.find_by_role( new_role_body['role'] ) 
            
            if !@exist
                puts "Registering new role..."
                @post.save 
                return 200, @post.to_json                 
            else
                msg = {"Error:"=>"Role already exist"}
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



    delete '/roles/:role' do
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
    
            delete_role = params[:role]
            puts delete_role

            @exist = Profile.find_by_role( delete_role ) 
            
            if !@exist
                msg = {"Error:"=>"Role does not exists"}
                json_output = JSON.pretty_generate (msg)
                puts json_output				
                return 409, json_output                                 
            else
                puts "Deleting role..."
                #@exists.delete
                Profile.find_by_role( delete_role ).delete
                msg = {"Success:"=>"Role deleted"}
                json_output = JSON.pretty_generate (msg)
                puts json_output                
                return 200, json_output  
                
                
            end 
        else
            msg = {"Error:"=>"Admin token required"}
            json_output = JSON.pretty_generate (msg)
            puts json_output				
            return 401, json_output         
        end
    end         

 