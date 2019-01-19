=begin
unless Role.exists?('admin')
  Role.create!([{
    role: "admin",
    description: "admin role default description"
  }])
end

unless User.exists?('tango')
  pwd = Digest::SHA1.hexdigest "t4ng0"

  user=User.create!({
    username: "tango",
    name: "tango",
    password: pwd,
    email: "tango@tango.com",
    status: "active"  
  })
  user.role = 'admin'
end
=end