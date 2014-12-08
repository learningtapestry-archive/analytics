#!/usr/bin/ruby
# this file will decrypt the deployment public key 
# and install it to ~/.ssh/id_lt

`cp ./secrets/id_lt_admin.pub ~/.ssh/id_lt_admin.pub`
`cp ./secrets/id_lt_admin ~/.ssh/id_lt_admin`
`chmod ugoa-rwx ~/.ssh/id_lt*`
`chmod u+rw ~/.ssh/id_lt*`
