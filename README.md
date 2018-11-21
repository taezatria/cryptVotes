# cryptVotes

### **Requirements** :
* build-essential patch nodejs zlib1g-dev liblzma-dev libsqlite3-dev
* mysql-server mysql-client libmysqlclient-dev (root password and skip-grant-tables)
* ruby-dev ruby-bundler redis-server (ruby 2.5.1)
* gem install rails (rails 5.2.1)
* **bundle install**
* create cryptAdmin on MySQL
* rake db:create & migrate & seed
* cp multichain/params.dat ~/.multichain-cold/cryptvotechain/
* foreman start

### **Multichain Explorer**
* sqlite3 sqlite3-dev python-dev python-pip
* pip install --upgrade pip
* pip install pycrypto
