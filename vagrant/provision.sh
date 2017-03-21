#!/usr/bin/env bash

# OS Updates
apt-get update -y

# Bash Profile Modifications
# Enable console colors
sed -i '1iforce_color_prompt=yes' ~/.bashrc
# Automatically cd to the project directory on ssh
echo "cd /vagrant" >> /home/vagrant/.bashrc
# Disable documentation during gem install
echo 'gem: --no-rdoc --no-ri' >> ~/.gemrc

# Ruby
RUBY_VERSION="2.3.3"
RUBY_VERSION_GENERAL="2.3"
sudo wget ftp://ftp.ruby-lang.org/pub/ruby/$RUBY_VERSION_GENERAL/ruby-$RUBY_VERSION.tar.gz
sudo apt-get install -y build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison nodejs subversion
tar xvfz ruby-$RUBY_VERSION.tar.gz
cd ruby-$RUBY_VERSION
./configure
make
sudo make install
sudo gem update --system
cd ..
rm -f ruby-$RUBY_VERSION.tar.gz
rm -rf ruby-$RUBY_VERSION

# Bundler
sudo gem install bundle

# Postgres
POSTGRES_VERSION="9.4"
sudo su
sudo touch /etc/apt/sources.list.d/pgdg.list
echo "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql-$POSTGRES_VERSION postgresql-contrib-$POSTGRES_VERSION postgresql-server-dev-$POSTGRES_VERSION

# Redis
# REDIS_VERSION="2.8.13"
# wget http://download.redis.io/releases/redis-$REDIS_VERSION.tar.gz
# tar xzf redis-$REDIS_VERSION.tar.gz
# cd redis-$REDIS_VERSION
# make
# sudo make install
# echo -n | sudo utils/install_server.sh
# cd ..
# rm -rf redis-$REDIS_VERSION
# rm redis-$REDIS_VERSION.tar.gz

# Bundle install app
cd /vagrant
bundle install

# Clean
sudo apt-get clean
