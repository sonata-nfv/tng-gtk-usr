# tng-gtk-usr
<p align="center"><img src="https://github.com/sonata-nfv/tng-api-gtw/wiki/images/sonata-5gtango-logo-500px.png" /></p>

# 5GTANGO API for the user management
This is the 5GTANGO API for the user management (built on top of [SONATA](https://github.com/sonata-nfv)) repository.

Please see [details on the overall 5GTANGO architecture here](https://5gtango.eu/project-outcomes/deliverables/2-uncategorised/31-d2-2-architecture-design.html). 

## How does this work?

This si designed to be used with dockers. Using the Dockerfile you can build and run the container. It will connect to he postgresql DB of the tango project (son-postgress container).

Once done, you will have the api available at http://tng-gtk-usr:4567 with this endpoints:

## /register: 
For the creation of new users

## /login: 
Login into the 5GTano Portal. This will create a token.

## /get_role: 
It will use the token, decode it and will give you the role for the selected user.

## /get_role_enpoint: 
It will use the token, decode it and will give you the list of endpoints available for the selected user.

## /get_all: 
This will give you a list of all the users.

## /get_all_roles: 
This will give you a list of all the roles and endpoints available for the users.



## Versioning

For the versions available, see the [link to releases on this repository](/releases).

## Licensing

For licensing issues, please check the [Licence](https://github.com/sonata-nfv/tng-gtk-usr/blob/master/LICENSE) file.

