# tng-gtk-usr
<p align="center"><img src="https://github.com/sonata-nfv/tng-api-gtw/wiki/images/sonata-5gtango-logo-500px.png" /></p>

# 5GTANGO API for the user management
This is the 5GTANGO API for the user management (built on top of [SONATA](https://github.com/sonata-nfv)) repository.

Please see [details on the overall 5GTANGO architecture here](https://5gtango.eu/project-outcomes/deliverables/2-uncategorised/31-d2-2-architecture-design.html). 

## How does this work?

This si designed to be used with dockers. Using the Dockerfile you can build and run the container. It will connect to he postgresql DB of the tango project (son-postgress container).

Once done, you will have the api available at http://tng-gtk-usr:4567 with this endpoints:

## /users: 
GET
	This will give you a list of all the users.
POST
	You will create a new user. You need this info:
		- Name
		- Email (this must be unique)
		- Password
		- Role
		- Status

## /users/:email
GET
	This will give you the information about this user

## /login: 
POST
	Login into the 5GTango Portal. This will create and return a user token.

## /users/:email/roles 
GET
	This will give you the role for the selected user. You need an admin token to access this info.

POST
	Here you can change the roles of the user account. You need an admin token to change this info. The body must have a `JSON` document with the list of roles to be added. E.g., `{"roles": [ "admin", "developer", "customer"]}`.
	
Note: we need to decide if a user may have more than one role at the same time or not.

## /users/:email/status
GET
	This will give you the status for the selected user. You need an admin token to access this info.
POST 
       Here you can change the status of the user account. You need an admin token to change this info. The body must have a `JSON` document with the status to be given. E.g., `{"status": "active"}`.

## /users/:email
PATCH 
       Here you can change the password of the user account. You need an admin token to change this info. The body must have a `JSON` document with the new password. E.g., `{"password": "5g7ang0"}`. Note: passwords are saved encripted.

## /users/:email/get_role_endpoints ??
GET
	This will give you the status for the selected user. You need an admin token to access this info.

## /users/roles
GET
	This will give you a list of all the roles and endpoints available for the users.




## Versioning

For the versions available, see the [link to releases on this repository](/releases).

## Licensing

For licensing issues, please check the [Licence](https://github.com/sonata-nfv/tng-gtk-usr/blob/master/LICENSE) file.

