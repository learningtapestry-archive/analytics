==Dev Box Config Checklist==
_For setting up Lubuntu, which is a minimally configured Ubuntu)_

vbox shared folder "[x]:\dev" to "/dev"
Sym link dev to home folder
  ln -s /media/sf_dev /home/steve/dev
Add user steve to group vboxsf
  sudo usermod -a -G vboxsf steve
logout/in
Install core tools:
```
sudo apt-get install gcc
sudo apt-get install make
sudo apt-get -y install postgresql-9.4
sudo apt-get -y install pgadmin3
sudo apt-get -y  install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libcurl4-openssl-dev libreadline-dev
```
*Ruby 1.9.3
  * Install rbenv
```
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
```
  * Run `rbenv rehash` after install gems that install shell commands (like rake)
  * Install ruby-build
```
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
```
  * Install Ruby: 
```
rbenv install 1.9.3-p551
rbenv global 1.9.3-p551
rbenv local 1.9.3-p551
rbenv rehash
```
* Install Bundler
```
sudo /home/steve/.rbenv/shims/gem install bundle
rbenv rehash
```
Java JRE
*Git
SmartGit
Chrome
* bundle install
* Install python 2.7 & dev libs
```
python 2.7 from package manager
sudo apt-get install python-dev libxml2-dev libxslt-dev
```
* [[Install python-pip]]

* [[Install ansible]]
```
sudo pip install ansible
# for managing digital ocean account via api
sudo pip install dopy
# for accessing keypass protected ssh files within ansible
sudo apt-get install sshpass
```
