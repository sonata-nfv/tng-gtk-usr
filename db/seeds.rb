
Profile.create!([{
  role: "admin",
  description: "admin role default description"
}])


pwd = Digest::SHA1.hexdigest "t4ng0"

User.create!([{
  username: "tango",
  name: "tango",
  password: pwd,
  email: "tango@tango.com",
  role: "admin",
  status: "active"  
}])

