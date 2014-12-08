Server Configuration
====================
# Production Server Management notes

1. Setup ssh public/private keys
  1. Find keys in LastPass and follow instructions there
1. Establish Pg tunnel:
```
ssh -i ~/.ssh/id_lt_admin ltdbadmin@db01.learningtapestry.com -L 5432:10.132.196.50:5432
```
  1. Setup pgadmin3 to connect to localhost:5432 over ssl
1. Establish connection to prod / Redis tunnel:
```
ssh -i ~/.ssh/id_lt_admin ltwebadmin@web01.learningtapestry.com -L 6378:localhost:6379
```
  1. Setup Redis Desktop Manager to connect to localhost:6378
  1. Open multiple terminals in byobu terminal manager
    1. Ctrl-A C
  1. Switch between open terminals 
    1. Ctrl-A [0-9]
1. How to edit postgres config files
  1. Find conf files in: /etc/postgresql/9.3/main
  1. When necessary, restart postgres to reload conf files
```
sudo /etc/init.d/postgresql restart 
```
1. View nginx config file
```
sudo more /etc/nginx/nginx.conf
```
1. Reload nginx config file
```
sudo nginx -s reload
```
1. Managing Unicorn
```
sudo service unicorn start
sudo service unicorn stop
sudo service unicorn restart
```
1. Restart server
```
sudo reboot now
```
1. Interact with application code:
```
cd /opt/learningtapestry/core-app
rake lt:console
```
1. Update source code from git master
```
cd /opt/learningtapestry/core-app
git fetch origin
# Github password is in LastPass under "LT prod Github PK"
sudo git reset --hard origin/master
sudo chown -R nobody:www-data /opt/learningtapestry/core-app
sudo chmod -R ugoa-rwx /opt/learningtapestry/core-app
sudo chmod -R ug+rx /opt/learningtapestry/core-app
sudo chmod -R ug+w /opt/learningtapestry/core-app/log
sudo chmod -R ug+w /opt/learningtapestry/core-app/tmp
sudo chmod ug+w /opt/learningtapestry/core-app/db/schema.rb 
# needs to provide sudo password for unattended install
bundle install
rake db:migrate
sudo service unicorn restart
```
1. Create a new Organization
  1. From lt:console:
```
o = Organization.create(name: 'Learning Tapestry', org_api_key: SecureRandom.uuid)
```
1. Sample client configuration script tag (for Learning Tapestry org in prod):
```
<script src="https://api.learningtapestry.com/api/v1/loader.js?username=stevemidgley&org_api_key=5eb4766f-34db-41d5-a1a4-29dc73ac99e2&load=collector&autostart=true"></script>
```
1. Manually run Janitor raw message process:
```
cd /opt/learningtapestry/core-app
rake lt:console
require File::join(LT::janitor_path,'redis_postgres_extract.rb')
LT::Janitors::RedisPostgresExtract::redis_to_raw_messages
LT::Janitors::RawMessagesExtract::raw_messages_to_page_visits
```
1. Reload Postgres configuration
  1. Login to db server
```
sudo -u postgres /usr/lib/postgresql/9.3/bin/pg_ctl reload -D /var/lib/postgresql/9.3/main
```
1. To interact with PG via psql on command line from server
```
sudo -u postgres psql
```

# lt01-dev.betaspaces.com

## Role: Test/Development Server

### Configuration Specifications

* Hostname:  lt01-dev.betaspaces.com
* IP address: 104.131.236.66
* OS Type:  Ubuntu 14.04 LTS (64-bit)
* Hardware:  2GB Ram, 40GB SSD Disk
* Hosting:  DigitalOcean @ New York 2
* Server Components:  Postgres 9.3, Nginx version openresty/1.7.2.1, ruby 1.9.3p484

### Configuration Notes

* Automated updates are set for this machine for "security" and "updates".  **Important:** The machine will automatically reboot when new updates are detected and a reboot is required.  The machine may disappear for 2-3 minutes at anytime during security updates.  This happens once per week or so, however defaulting on better security as opposed to max uptime on a single box.

* This server is using CruiseControl.rb (CCrb) for CI.  The user context is "learntac".  CCrb is set to run on startup in /etc/rc.local (tested).  CCrb will pull from GitHub science/lt project every 5 minutes.  If a change has been detected, it will kick off a new build.  If the status changes been success to failure or vise-versa, it will send an email to Jason and Steve.  CCrb has a web dashboard to view job status at port 3333, however this is currently blocked by the firewall. Planning to make accessible only via SSH or OpenVPN access for security in future.  Project directory is /home/learntac/.cruise/projects/learntaculous/work.  CCrb is /home/learntac/Procjects/cruisecontrol.rb. **NOTE:**  learntac doesn't have sudo access, so new gems may break a build until ran manually on server.

* Server needs phantomjs installed for testing.

### To Dos

* Improvement:  git can't pull down just sub-folders, so CCrb uses ./core-app/run-tests.rb to trigger builds.  Because not a sub-folder, builds will trigger on any LT git check-in.

* Improvement:  Start CCrb in a process monitor for better durability.

### Thin References

* http://jordanhollinger.com/2011/04/22/how-to-use-thin-effectivly/

* http://code.macournoyer.com/thin/usage/

# Server Management Notes

* Server is located at: lt-dev01.learntaculo.us
  * When connecting via vpn:
    * Set virtualbox network adapter to bridged
      * To get VB options: right-ctrl-home
    * nmcli con up id lt-dev01
    * ssh steve@192.168.247.1
  * When disconnecting from vpn:
    * Exit all shells
    * nmcli con down id lt-dev01
    * Set virtualbox network adapter to NAT

* To mess with the CI server go to this folder for the code:
`/home/learntac/.cruise/projects/core-app`

* byobu: multi-terminal window manager
  * byobu-enable/disable: turn this service on/off
  * ctrl-a: screen manager
  * ctrl-a-c: new terminal
  * ctrl-a-[0-9]: switch between terminals
  * ctrl-a-d: detach from server (logout)
* learntac CI/pg local user
* /home/learntac: folder for system
  * sudo -su learntac: to become this user
  * /home/learntac/Projects
    * ./cruisecontrol.rb: code for cruisecontrol
      * /home/learntac/.cruise: CI build of code
  * /var/www/learntaculous/core-app: web server build of code
  * /etc/thin/webapp.yml: config for thin
    * sudo service thin restart: reboot thin
    /home/learntac/core-app/log: thin logs
  * /etc/nginx/web-sites.confg: nginx configuration file
    * sudo service nginx restart
    * /var/log/nginx: nginx logs
  * VPN
    * On lt-dev01: /etc/ppp/chap-secrets: holds user/pass credentials
    * In local vbox: use bridged network, not NAT to connect to VPN
    * Local config for PPTP: MSCHAPv2/128bit MPPE
    * start/stop VPN: nmcli con [up|down] id lt-dev01
  * PG
    * user lt_dbo
    * 192.168.247.1
  * Cruisecontrol CI
    * 192.168.247.1:3333

Thin-rack-ruby 502 failure
  Possible explanation: when ruby raises an exception, it causes thin to terminate which leaves sockets open from nginx but no handler to process requests

Chrome: Advanced REST client




