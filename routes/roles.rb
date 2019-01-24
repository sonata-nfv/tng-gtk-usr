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
require 'tng/gtk/utils/logger'
require_relative '../models/role'

get '/roles' do
  roles = Role.where.not(role: '-')
  return 200, roles.to_json      
end

post '/roles' do
  body = request.body.read
  return 400, {error: "Role name and description are required parameters"}.to_json if body.empty?
  params=JSON.parse(body, symbolize_names: true)
  return 400, {error: "Role name is required"}.to_json unless (params.key?(:role) && !params[:role].empty?)
  return 400, {error: "Role name #{params[:role]} is not valid"}.to_json if params[:role] == '-'
  return 400, {error: "HTTP Authorirization header must contain bearer token"}.to_json unless request.env["HTTP_AUTHORIZATION"]
  token = request.env["HTTP_AUTHORIZATION"].split(' ')[1]
  decoded_token = JWT.decode(token, SECRET)
  return 403, {error: 'Only users with the \'admin\' role can add roles'}.to_json unless decoded_token[0]['role'] == 'admin'
    
  role = Role.new( params )
  return 404, {error: "Error saving role #{params}"}.to_json unless role.save
  return 201, role.to_json                 
end     

delete '/roles/:role' do
  return 400, {error: "Role name is a required parameter"}.to_json if params[:role].empty?
  return 400, {error: "Role name #{params[:role]} is not valid"}.to_json if params[:role] == '-'
  token = request.env["HTTP_AUTHORIZATION"].split(' ')[1]
  decoded_token = JWT.decode(token, SECRET)
  return 403, {error: 'Only users with the \'admin\' role can delete roles'}.to_json unless decoded_token[0]['role'] == 'admin'
    
  Role.find(params[:role]).delete
  return 204, {}                
end         

