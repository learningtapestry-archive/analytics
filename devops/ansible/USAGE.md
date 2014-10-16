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

### Setup

1. Create /etc/ansible if not already created
2. Create an *inventory* file of /etc/ansible/hosts with IP or hostname of machines

### Commands

- ```ansible -i [inventory/host file]``` - run with host parameter instead of /etc/ansible

Below: [target] can be: all, IP address, hostname or group defined in inventory

- ```ansible [target] -m ping``` - Ping all machines in Ansible inventory (host file)
- ```ansible [target] -a "/bin/unixcommand param"``` - Run a command on a target machine
- ```ansible webservers -m apt -a "name=acme state=installed"``` - Check package version (NOTE: this actually installed the package, different from docs)
- ```ansible [target] -m apt -a "name=nginx state=removed"``` - Ensure a package is not installed  (NOTE: this actually removed the package, different from docs)
- ```ansible [target] -m git -a "repo=git://foo.example.org/repo.git dest=/srv/myapp version=HEAD"``` - Deploying from source control
- ```ansible [target] -m setup``` - Discovering facts from machine, hardware, network config, Linux distro, etc.