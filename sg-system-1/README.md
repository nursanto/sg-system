# SG System 1

## Table of Contents
* [My slide](./materials/)
* [Install Devstack](#Install-Devstack)
* [Openstack Operations](#Openstack-Operations)


### Install Devstack
##### a. create user and add root permision
	adduser stack
	echo "stack ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/stack
	chmod 440 /etc/sudoers.d/stack
	su - stack

##### b. clone devstack github repository
	git clone https://github.com/openstack/devstack.git
	cd devstack

##### c. edit devstack configuration
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

##### d. run installation script
	tmux
	./stack.sh


### Openstack Operations
##### a. create user, project
	openstack project create --description 'dept system project' dept-system
	openstack project list
	openstack user create --password qqqqq myuser
	openstack user list
	openstack role assignment list --user myuser --project dept-system
	openstack role assignment list --user myuser --project dept-system --names

##### b. create network, router
	openstack network list
	openstack network create mynetwork
	openstack subnet list
	openstack subnet create mysubnet --network mynetwork --subnet-range 192.0.2.0/24 --dns-nameserver 8.8.8.8
	openstack router create myrouter
	openstack router set myrouter --external-gateway public
	openstack router add subnet myrouter mysubnet

##### c. create instance
	openstack image list
	openstack network list
	openstack flavor list
	openstack server create --image cirros-0.4.0-x86_64-disk --flavor m1.nano --network mynetwork myinstance

##### d. associate floating IP
	openstack floating ip create public
	openstack floating ip list
	openstack server list
	openstack server add floating ip myinstance 172.24.4.73  ## ip from "openstack floating ip list"
	openstack server list

##### e. create security group and add to instance
	openstack security group create mysecgroup --description "allow ping and ssh"
	openstack security group list
	openstack security group rule create mysecgroup --protocol tcp --dst-port 22:22 --remote-ip 0.0.0.0/0
	openstack security group rule create mysecgroup --protocol icmp
	openstack security group rule list mysecgroup
	openstack server add security group myinstance  mysecgroup



	

