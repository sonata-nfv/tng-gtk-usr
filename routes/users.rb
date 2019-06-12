## Copyright (c) 2015 SONATA-NFV, 2017 5GTANGO [, ANY ADDITIONAL AFFILIATION]
## ALL RIGHTS RESERVED.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
## Neither the name of the SONATA-NFV, 5GTANGO [, ANY ADDITIONAL AFFILIATION]
## nor the names of its contributors may be used to endorse or promote
## products derived from this software without specific prior written
## permission.
##
## This work has been performed in the framework of the SONATA project,
## funded by the European Commission under Grant number 671517 through
## the Horizon 2020 and 5G-PPP programmes. The authors would like to
## acknowledge the contributions of their colleagues of the SONATA
## partner consortium (www.sonata-nfv.eu).
##
## This work has been performed in the framework of the 5GTANGO project,
## funded by the European Commission under Grant number 761493 through
## the Horizon 2020 and 5G-PPP programmes. The authors would like to
## acknowledge the contributions of their colleagues of the 5GTANGO
## partner consortium (www.5gtango.eu).
# frozen_string_literal: true
# encoding: utf-8
require 'tng/gtk/utils'
require_relative '../models/user'



get '/users' do
  @users = User.all
  #puts @users.to_json
  Tng::Gtk::Utils::Logger.debug(component:'users', operation:'getting all users', message:@users.to_json)     
  @users.to_json
end

get '/users/:username' do
  @user = User.find_by_username(params[:username])
  @user.to_json
end

post '/users' do

  user = JSON.parse(request.body.read)
  user['password'] =  Digest::SHA1.hexdigest(user['password'])

  # role will be saved as an association
  role = user.delete('role')
  #puts "user=#{user.inspect}"
  Tng::Gtk::Utils::Logger.debug(component:'users', operation:'user from body', message:user='user=#{user.inspect}') 

  puts "validating mail"
  if EmailValidator.valid?(user['email'])
    #puts "valid email"
    Tng::Gtk::Utils::Logger.debug(component:'users', operation:'email', message:user="valid email") 
  else
    #puts "invalid email"
    Tng::Gtk::Utils::Logger.debug(component:'users', operation:'email', message:user="invalid email") 
    msg = {error: "Invalid email: #{user[email]}"}			
    return 409, msg.to_json             
  end

  in_memory_role = Role.find_by_role( role ) 
    
  if in_memory_role 
    unless User.find_by_username(user['username'])
      begin
        in_memory_user = User.new( user )
        #STDERR.puts "in_memory_user=#{in_memory_user.inspect}"
        Tng::Gtk::Utils::Logger.debug(component:'users', operation:'save user', message:user="in_memory_user=#{in_memory_user.inspect}") 
        in_memory_user.role = in_memory_role
        #STDERR.puts "in_memory_user=#{in_memory_user.inspect}"
        Tng::Gtk::Utils::Logger.debug(component:'users', operation:'save role', message:user="in_memory_user=#{in_memory_user.inspect}") 
        in_memory_user.save!
        return 200, in_memory_user.to_json
      rescue => e
        msg = {error:"User saving failled: #{e.message}\n#{e.backtrace.join("\n\t")}"}
        return 500, msg.to_json  
      end
    else
      msg = {error: "User #{user['username']} already exist"}
      return 409, msg.to_json              
    end
  else
    msg = {error:"Role #{role} does not exist"}
    return 404, msg.to_json
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
    #puts request.env["HTTP_AUTHORIZATION"]
    Tng::Gtk::Utils::Logger.debug(component:'users', operation:'password', message:user=request.env["HTTP_AUTHORIZATION"]) 
    decoded_token = JWT.decode(request.env["HTTP_AUTHORIZATION"], SECRET)

    decoded = decoded_token.to_json

    parsed = JSON.parse (decoded)

    decoded_username = parsed[0]['username']
    username_for_password = "#{params[:username]}"
    #puts "decoded user : " + decoded_username.to_s  
    Tng::Gtk::Utils::Logger.debug(component:'users', operation:'password', message:user=decoded_username.to_s)   
    #puts "user for password : " + username_for_password.to_s
    Tng::Gtk::Utils::Logger.debug(component:'users', operation:'password', message:username_for_password.to_s)


    @user = User.find_by_username( decoded_username )
    #puts "token user decoded"
    Tng::Gtk::Utils::Logger.debug(component:'users', operation:'password', message:"token user decoded")
    #puts @user['username']

    if @user['role'] == "admin"

        @user_for_password = User.find_by_username( username_for_password ) 

        if @user_for_password



            new_password_body = JSON.parse(request.body.read)
            #puts new_password_body
            Tng::Gtk::Utils::Logger.debug(component:'users', operation:'password', message:new_password_body)
            new_password = new_password_body['password']
            #puts new_password
            Tng::Gtk::Utils::Logger.debug(component:'users', operation:'password', message:new_password)

            new_password_encrypted = Digest::SHA1.hexdigest new_password
            #puts "new password encrypted"
            #Tng::Gtk::Utils::Logger.debug(component:'users', operation:'password', message:"new password encrypted")
            #puts new_password_encrypted
            Tng::Gtk::Utils::Logger.debug(component:'users', operation:'password', message:new_password_encrypted)

            #luis = Digest::SHA1.hexdigest 'luis'
            #puts "luis encrypted"
            #puts luis
            
            @user_for_password.update_attribute(:password, new_password_encrypted)
            msg = {"Success:"=>"User password updated"}
            json_output = JSON.pretty_generate (msg)
            #puts json_output
            Tng::Gtk::Utils::Logger.debug(component:'users', operation:'password', message:json_output)				
            return 200, json_output             
        else 
            msg = {"error:"=>"Unregistered user"}
            json_output = JSON.pretty_generate (msg)
            #puts json_output	
            Tng::Gtk::Utils::Logger.debug(component:'users', operation:'password', message:json_output)				
            return 409, json_output             
        end

    else
        msg = {"error:"=>"Admin token required"}
        json_output = JSON.pretty_generate (msg)
        #puts json_output
        Tng::Gtk::Utils::Logger.debug(component:'users', operation:'password', message:json_output)					
        return 401, json_output         
    end
end


get '/users/:username/endpoints' do

    #puts request.env["HTTP_AUTHORIZATION"]
    Tng::Gtk::Utils::Logger.debug(component:'users', operation:'endpoints', message:request.env["HTTP_AUTHORIZATION"])	
    decoded_token = JWT.decode(request.env["HTTP_AUTHORIZATION"], SECRET)

    decoded = decoded_token.to_json

    parsed = JSON.parse (decoded)

    decoded_username = parsed[0]['username']
    username_for_endpoints = "#{params[:username]}"
    #puts "decoded user : " + decoded_username.to_s
    Tng::Gtk::Utils::Logger.debug(component:'users', operation:'endpoints', message:decoded_username.to_s)    
    #puts "user for endpoints : " + username_for_endpoints.to_s
    Tng::Gtk::Utils::Logger.debug(component:'users', operation:'endpoints', message:username_for_endpoints.to_s)


    @user = User.find_by_username( decoded_username )
    #puts "token user decoded"
    #puts @user['username']

    if @user['role'] == "admin"

        @user_for_endpoints = User.find_by_username( username_for_endpoints ) 

        if @user_for_endpoints

            #puts @user_for_endpoints['role']
            Tng::Gtk::Utils::Logger.debug(component:'users', operation:'endpoints', message:@user_for_endpoints['role'])
            role = @user_for_endpoints['role']

            #@endpoints = Role.where(role: role )
            #@endpoints = Role.where(role: role ).select("endpoint").all
            @endpoints = Permission.where(role: role ).select("endpoint", "verbs").all

            @endpoints.to_json

        else 
            msg = {"error:"=>"Unregistered user"}
            json_output = JSON.pretty_generate (msg)
            #puts json_output
            Tng::Gtk::Utils::Logger.debug(component:'users', operation:'endpoints', message:json_output) 				
            return 404, json_output            
        end

    else
        msg = {"error:"=>"Admin token required"}
        json_output = JSON.pretty_generate (msg)
        #puts json_output
        Tng::Gtk::Utils::Logger.debug(component:'users', operation:'endpoints', message:json_output) 				
        return 401, json_output
    end
end


delete '/users' do
    @users = User.destroy_all
    msg = {"Success:"=>"All users deleted"}
    json_output = JSON.pretty_generate (msg)
    puts json_output				
    return 200, json_output
end
