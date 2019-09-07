# vi: set ft=ruby :
# -*- mode: ruby -*-

Vagrant.configure(2) do |config|
	config.vm.box = "ubuntu/trusty64"
	config.vm.hostname = "jekyll"
	config.vm.network "forwarded_port", host: 80, guest: 80
	
	config.vm.provision "shell", inline: <<-SHELL
		sudo apt-get -y update
		sudo apt-get -y upgrade
		sudo apt-get -y install gnupg2 \
			software-properties-common \ 
			rvm \

		sudo apt-add-repository -y ppa:rael-gc/rvm
	SHELL
	config.vm.provision "shell", path: "bootstrap.sh"
	config.ssh.forward_agent = true
end
