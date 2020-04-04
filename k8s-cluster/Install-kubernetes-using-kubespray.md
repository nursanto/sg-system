# Install kubernetes using kubespray

## Post Install, do on all node
	# check partition size and extend if needed
	fdis -l
	lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
	resize2fs /dev/ubuntu-vg/ubuntu-lv

	# install python, requirement for ansible
	apt install python

## Install kubernetes, do from deployment node or one of the nodes
	# generete ssh key
	ssh-keygen

	# copy ssh key to all node. include node where you are. 
	ssh-copy-id <ip address>

	# install pip3
	apt install python3-pip

	# clone kubespray repository
	git clone https://github.com/kubernetes-sigs/kubespray.git
	cd kubespray/

	# install requirement for deploymeny
	pip3 install -r requirements.txt

	# copy template deployment kubernetes
	cp -rfp inventory/sample inventory/mycluster

	# decalare ip address of nodes
	declare -a IPS=(10.0.0.11 10.0.0.12 10.0.0.13)

	# generete inventory for deployment
	CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

	# file containing the configuration. see line 23 if want to change kubernetes version.
	cat inventory/mycluster/group_vars/all/all.yml

	# file containing the configuration
	cat inventory/mycluster/group_vars/k8s-cluster/k8s-cluster.yml

	# test ansible conectifity 
	ansible all -i inventory/mycluster/hosts.yaml -m ping

	# deploy kubernetes ,its take about 50 minute depend internet speed and your nodes
	ansible-playbook -i inventory/mycluster/hosts.yaml  --user=root cluster.yml

	# cluster verification
	kubectl cluster-info
	kubectl get node -o wide

	# test deploy nginx
	kubectl run nginx --image nginx --replicas 3
	kubectl expose deployment nginx --type NodePort --port 80
	NODEPORT=$(kubectl get -o jsonpath="{.spec.ports[0].nodePort}" services nginx)
	NODES=$(kubectl get node -o wide | head -n2 | tail -n1 | awk {'print $6'})
	curl $NODES:$NODEPORT

	# delete test nginx
	kubectl delete deployment nginx
	kubectl delete service nginx
