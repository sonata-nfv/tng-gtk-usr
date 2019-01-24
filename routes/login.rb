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
post "/login" do
  body = request.body.read
  return 400, {error: "User name and password are required parameters"}.to_json if body.empty?
  params=JSON.parse(body, symbolize_names: true)
  return 400, {error: "User name is required"}.to_json unless (params.key?(:username) && !params[:username].empty?)
  return 400, {error: "Passord is required"}.to_json unless (params.key?(:password) && !params[:password].empty?)
	
	user = User.find_by(username:params[:username]).as_json
	return 404, {error: "Wrong user or password"}.to_json unless user
	return 403, {error: "Unauthorized, wrong user or password"}.to_json unless user['password'] == Digest::SHA1.hexdigest(params[:password])
	t_now = Time.now			
	payload = { username: user['username'], name: user['name'], role: user['role'].role, email: user['email'], login_time: t_now, expiration_time: t_now + 3600}
	return 200, {token: JWT.encode(payload, SECRET,'HS256')}.to_json
end

delete "/login" do
end

