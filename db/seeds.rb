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
roles={}
roles[:none]= Role.find_or_create_by(role: '-') do |role|
  STDOUT.puts "Adding '-' (no role) role..."
  role.description = 'No role'
end
[:admin, :customer, :developer].each do |role_name|
  roles[role_name]= Role.find_or_create_by(role: role_name.to_s) do |role|
    STDOUT.puts "Adding '#{role_name.to_s} role..."
    role.description = "#{role_name.to_s.capitalize} role"
  end
end

User.find_or_create_by(username: 'tango') do |admin_user|
  STDOUT.puts "Adding 'tango' user ('admin' role -- please use this user to loging, create (an)other user(s) and chenge some to 'admin' role)..."
  admin_user.password = Digest::SHA1.hexdigest 't4ng0'
  admin_user.name = '5GTANGO'
  admin_user.email = 'tango@tango.com'
  admin_user.status = 'active'
  admin_user.role = roles[:admin]
end
=begin
[
  {endpoint: '/', role: roles[:none], verbs: 'get,options'},
  {endpoint: '/api/v3', role: roles[:none], verbs: 'get,options'},
  {endpoint: '/api/v3/users', role: roles[:none], verbs: 'post'},
  {endpoint: '/api/v3/users/sessions', role: roles[:none], verbs: 'post'},
  {endpoint: '/api/v3/users', role: roles[:admin], verbs: 'get,delete,options,patch,post'},
  {endpoint: '/api/v3/packages', role: roles[:admin], verbs: 'get,delete,options,post'},
  {endpoint: '/api/v3/services', role: roles[:admin], verbs: 'get,options'},
  {endpoint: '/api/v3/functions', role: roles[:admin], verbs: 'get,options'},
  {endpoint: '/api/v3/packages/:uuid/', role: roles[:admin], verbs: 'get,delete,options,post'}
].each do |permission|
  next if Permission.find_by_sql("SELECT * FROM permissions INNER JOIN roles ON permissions.role = roles.role AND roles.role = '#{permission[:role].role}' AND permissions.endpoint='#{permission[:endpoint]}'")
  p=Permission.new(endpoint: permission[:endpoint], verbs:permission[:verbs])
  p.role = permission[:role]
  p.save!
end
=end