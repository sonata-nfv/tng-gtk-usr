# tng-gtk-usr
<p align="center"><img src="https://github.com/sonata-nfv/tng-api-gtw/wiki/images/sonata-5gtango-logo-500px.png" /></p>

# 5GTANGO API for the user management
This is the 5GTANGO API for the user management (built on top of [SONATA](https://github.com/sonata-nfv)) repository.

Please see [details on the overall 5GTANGO architecture here](https://5gtango.eu/project-outcomes/deliverables/2-uncategorised/31-d2-2-architecture-design.html). 

## How does this work?

This si designed to be used with dockers. Using the Dockerfile you can build and run the container. It will connect to he postgresql DB of the tango project (son-postgress container).

Once done, you will have the api available at http://tng-gtk-usr:4567 with this endpoints:

## /users
*GET

	This will give you a list of all the users.

*POST
	You will create a new user. You need this info:

	{
		"username":"my_username",
		"name":"my_name",		
		"password":"my_password",
		"email":"my_email@my_email.com",
		"role":"my_role"
	}

By default, the status of the user is "admin". It can be changed later with the Patch operation.



## /users/:username

*GET

	This will give this user info

*PATCH
	You will modify a user. You need this info:

	{
		"status":"cancelled",
		"password":"luis",
		"role":"customer",
		"email":"luis_new@luis_new.com"
	}
By default, the status of the user is "admin". It can be changed later with the Patch operation.


## /login 
POST

Login into the 5GTango Portal. This will create and return a user token.
The user's Token is need for the other operations. For example:
	
- Admin token is needed to modify the status of and user, give "admin" role or establish the password empty.
	
- Normal user token can modify that user info, email, password, ls
status and role (nom admin).


## /endpoints

GET

This will give you a list of all the roles and endpoints (with verbs) available for the users.

POST

This will create a new endpoint. Admin token required. Example:

	{
		"role":"admin",
		"endpoint":"packages",
		"verbs":"get,post,put"
	}


## /endpoints/:username

GET

This will give you a list of all the roles and endpoints (with verbs) available for that user.


## Versioning

For the versions available, see the [link to releases on this repository](/releases).

## Licensing

For licensing issues, please check the [Licence](https://github.com/sonata-nfv/tng-gtk-usr/blob/master/LICENSE) file.

