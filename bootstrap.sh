#!/usr/bin/env bash

# Install RVM so we can run a recent version of Jekyll.
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | sudo bash -s stable 


#Add user to RVM group in order to install ruby
rvm group add rvm $USER

#Logout and log back in 

#Install ruby
rvm install ruby
# Install Jekyll an any other gems. You can also swap this out for bundler.
gem install jekyll bundler

# Create a new Jekyll site if one does not already exists
cd /vagrant
bundle install
jekyll new cluublog

# Run Jekyll, accessible on the host machine
cd cluublog
bundle exec jekyll serve --detach --host=0.0.0.0
