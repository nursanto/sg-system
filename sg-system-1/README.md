# SG System 1

## Table of Contents
* [Install Devstack](#Install-Devstack)
* [Create Instance](#Create-Instance)


### Install Devstack
##### create user and add root permision
	adduser stack
	echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
	chmod 440 /etc/sudoers.d/stack
	su - stack

##### clone devstack github repository
	git clone https://github.com/openstack/devstack.git
	cd devstack

##### edit devstack configuration
	cp samples/local.conf .
	vim local.conf

	[[local|localrc]]
	...
	enable_plugin heat https://opendev.org/openstack/heat
	enable_plugin heat-dashboard https://opendev.org/openstack/heat-dashboard
	...
	ADMIN_PASSWORD=qqqqq
	DATABASE_PASSWORD=qqqqq
	RABBIT_PASSWORD=qqqqq
	SERVICE_PASSWORD=$ADMIN_PASSWORD
	...
	HOST_IP=192.168.26.45	### ip addr host
	#HOST_IPV6=2001:db8::7
	...

##### run installation script
	tmux
	./stack.sh


### Create Instance
	access IP-Host from web browser