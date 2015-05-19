Server Configuration
====================

# Production Server Management notes

* Setup ssh public/private keys

  Find keys in LastPass and follow instructions there

* Establish Pg tunnel:

```shell
ssh -i ~/.ssh/id_lt_admin ltdbadmin@db01.learningtapestry.com -L 5432:10.132.196.50:5432
```

  - Setup pgadmin3 to connect to localhost:5432 over ssl

* Establish connection to prod / Redis tunnel:

```shell
ssh -i ~/.ssh/id_lt_admin ltwebadmin@web01.learningtapestry.com -L 6378:localhost:6379
```

  - Setup Redis Desktop Manager to connect to localhost:6378
  - Open multiple terminals in byobu terminal manager: Ctrl-A C
  - Switch between open terminals: Ctrl-A [0-9]

* How to edit postgres config files

  - Find conf files in: /etc/postgresql/9.3/main
  - When necessary, restart postgres to reload conf files

```shell
sudo /etc/init.d/postgresql restart 
```

* View nginx config file

```shell
sudo more /etc/nginx/nginx.conf
```

* Reload nginx config file

```shell
sudo nginx -s reload
```

* Restart nginx

```
sudo service nginx restart
```

* Restart server

```
sudo reboot now
```

* Interact with application code:

```
cd /opt/learningtapestry/analytics
rake lt:console
```

* Update source code from git master

```shell
cd /opt/learningtapestry/analytics
git fetch origin
# Github password is in LastPass under "LT prod Github PK"
sudo git reset --hard origin/master
sudo chown -R nobody:www-data /opt/learningtapestry/analytics
sudo chmod -R ugoa-rwx /opt/learningtapestry/analytics
sudo chmod -R ug+rx /opt/learningtapestry/analytics
sudo chmod -R ug+w /opt/learningtapestry/analytics/log
sudo chmod -R ug+w /opt/learningtapestry/analytics/tmp
sudo chmod ug+w /opt/learningtapestry/analytics/db/schema.rb
# needs to provide sudo password for unattended install
bundle install
rake db:migrate
sudo service unicorn restart
```

* Create a new Organization
  - From lt:console:

```ruby
o = Organization.create(name: 'Learning Tapestry', org_api_key: SecureRandom.uuid)
```

  - Sample client configuration script tag (for Learning Tapestry org in prod):

```ruby
<script src="https://api.learningtapestry.com/api/v1/loader.js?username=stevemidgley&org_api_key=5eb4766f-34db-41d5-a1a4-29dc73ac99e2&load=collector&autostart=true"></script>
```

* Manually run Janitor raw message process:

```shell
cd /opt/learningtapestry/analytics
rake lt:console
rake lt:janitors:import_raw_messages
rake lt:janitors:process_redis_page_messages
rake lt:janitors:process_redis_video_messages
```

* Login to db server

```shell
sudo -u postgres /usr/lib/postgresql/9.4/bin/pg_ctl reload -D /var/lib/postgresql/9.3/main
```

* Interact with PG via psql on command line from server

```shell
sudo -u postgres psql
```

* Cron job to run janitor

```shell
sudo crontab -e
*/5 * * * * sudo --user nobody --non-interactive echo && cd
/opt/learningtapestry/analytics && /usr/local/bin/rake RAILS_ENV=production lt:janitors:process_redis_messages > /opt/learningtapestry/analytics/log/cron-redis-janitor.txt 2> /tmp/err-cron-redis-janitor.txt
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

* Improvement:  git can't pull down just sub-folders, so CCrb uses ./run-tests.rb to trigger builds.  Because not a sub-folder, builds will trigger on any LT git check-in.

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
`/home/learntac/.cruise/projects/analytics`

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
  * /var/www/learntaculous/analytics: web server build of code
  * /etc/thin/webapp.yml: config for thin
    * sudo service thin restart: reboot thin
    /home/learntac/analytics/log: thin logs
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
