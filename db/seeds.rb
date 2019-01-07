unless Role.exists?('admin')
  Role.create!([{
    role: "admin",
    description: "admin role default description"
  }])
end

unless User.exists?('tango')
  pwd = Digest::SHA1.hexdigest "t4ng0"

  User.create!([{
    username: "tango",
    name: "tango",
    password: pwd,
    email: "tango@tango.com",
    role: "admin",
    status: "active"  
  }])
end
