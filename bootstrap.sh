#!/usr/bin/env bash

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install gnupg2

sudo apt-get install software-properties-common

sudo apt-add-repository -y ppa:rael-gc/rvm
sudo apt-get update
sudo apt-get install rvm

# Install RVM so we can run a recent version of Jekyll.
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | sudo bash -s stable 


#Add user to RVM group in order to install ruby
rvm group add rvm $USER

#Install ruby
rvm install ruby
# Install Jekyll an any other gems. You can also swap this out for bundler.
gem install jekyll, bundler

# Create a new Jekyll site if one does not already exists
cd /vagrant
if [ ! -f jekyll/_config.yml ]; then
	bundle exec jekyll new jekyll
fi

# Run Jekyll, accessible on the host machine
cd jekyll
bundle install
bundle exec jekyll serve --detach --host=0.0.0.0
