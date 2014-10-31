# Ansible Notes

## Installation

Easiest method if Python and Pip are installed:

```
sudo pip install ansible --update
```
Otherwise:

Easy install for Mac and Linux machines, follow: http://docs.ansible.com/intro_installation.html

From docs:  "Currently Ansible can be run from any machine with Python 2.6 installed (Windows isn’t supported for the control machine). This includes Red Hat, Debian, CentOS, OS X, any of the BSDs, and so on."

## Usage

**Important**:  Ansible runs by ssh keys by default.  The target machine must have the public key of the Ansible user in .ssh/authorized_keys for Ansible to function.

Helpful references in designing playbooks:  

- http://docs.ansible.com/playbooks.html
- https://github.com/ansible/ansible-examples
- http://docs.ansible.com/modules_by_category.html

### Learning Tapestry Operational Commands

- ```ansible -i hosts-prod web01 -m service -a "name=nginx state=started"```  Check on web01 that nginx is started (```state=restarted``` to restart service)
- 


### General Commands

- ```ansible -i [inventory/host file]``` - run with host file instead of the default /etc/ansible/hosts.  

Below: [target] can be: all, IP address, hostname or group defined in inventory

- ```ansible [target] -m ping``` - Ping all machines in Ansible inventory (host file)
- ```ansible [target] -a "/bin/unixcommand param"``` - Run a command on a target machine
- ```ansible webservers -m apt -a "name=acme state=installed"``` - Check package version (NOTE: this actually installed the package, different from docs)
- ```ansible [target] -m apt -a "name=nginx state=removed"``` - Ensure a package is not installed  (NOTE: this actually removed the package, different from docs)
- ```ansible [target] -m git -a "repo=git://foo.example.org/repo.git dest=/srv/myapp version=HEAD"``` - Deploying from source control
- ```ansible [target] -m setup``` - Discovering facts from machine, hardware, network config, Linux distro, etc.

### Starting Up
1. Ensure the LT prod private key stored at ~/.ssh/id_learntap
2. Ping all hosts:  ```ansible -i hosts-prod all -u root -m```, you should receive back a JSON messsage with success and "ping": "pong".
3. To ensure services are deployed to hosts, issue: ```ansible-playbook -i hosts-prod site.yml```
4. Login via: ssh -i ~/.ssh/id_learntap [username]@[hostname]

### To Dos

### First Deploy Log

```
jasons-air:ansible jason$ ansible-playbook -i hosts-prod site.yml

PLAY [apply common configuration to all nodes] ******************************** 

GATHERING FACTS *************************************************************** 
The authenticity of host 'web01.learningtapestry.com (104.131.171.144)' can't be established.
RSA key fingerprint is 7e:54:26:cf:d2:34:eb:e2:c8:1f:d6:38:7e:42:ef:fa.
Are you sure you want to continue connecting (yes/no)? yes
Warning: the RSA host key for 'web01.learningtapestry.com' differs from the key for the IP address '104.131.171.144'
Offending key for IP in /Users/jason/.ssh/known_hosts:55
Are you sure you want to continue connecting (yes/no)? yes
ok: [web01.learningtapestry.com]

TASK: [common | General | Install required packages] ************************** 
changed: [web01.learningtapestry.com] => (item=build-essential,unzip,ufw,byobu,ruby1.9.1,git)

PLAY [configure and deploy the webservers and application code] *************** 

GATHERING FACTS *************************************************************** 
ok: [web01.learningtapestry.com]

TASK: [web | Web | Install required packages] ********************************* 
changed: [web01.learningtapestry.com] => (item=nginx,openssl,postgresql-client-9.4)

PLAY [deploy Postgres and configure the databases] **************************** 

GATHERING FACTS *************************************************************** 
ok: [web01.learningtapestry.com]

TASK: [db | Web | Install required packages] ********************************** 
changed: [web01.learningtapestry.com] => (item=postgresql-9.4,postgresql-common,postgresql-server-dev-9.4)

PLAY RECAP ******************************************************************** 
web01.learningtapestry.com : ok=6    changed=3    unreachable=0    failed=0   

jasons-air:ansible jason$ 
```

