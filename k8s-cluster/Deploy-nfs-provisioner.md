# Deploy nfs provisioner

## Install nfs server
	# install package
	apt install nfs-kernel-server

	# create folder which will be shared
	mkdir -p /srv/nfs/kubedata

	# change permision
	chmod -R 777 /srv/nfs/

	# crete nfs configuration
	cat  >>/etc/exports<<EOF
	/srv/nfs/kubedata       *(rw,sync,no_subtree_check,insecure)
	EOF

	# restart nfs service
	exportfs -a
	systemctl restart nfs-kernel-server

## check nfs from another node	
	apt install nfs-common
	showmount x.x.x.x -e


## Deploy nfs provisioner3
	cd -
	git clone https://github.com/nursanto/sg-system.git
	cd sg-system/k8s-cluster/nfs-provisioner/

	#change provisioner hostname(line 7); ex. node1/nfs
	vim default-sc.yaml

	# change line 26, 28, 34
	vim deployment.yaml

	kubectl create -f rbac.yaml
	kubectl create -f deployment.yaml
	kubectl create -f default-sc.yaml

	kubectl get all
	kubectl get pv,pvc
	kubectl create -f pvc-nfs.yaml
	kubectl get pv,pvc
	kubectl delete -f pvc-nfs.yaml