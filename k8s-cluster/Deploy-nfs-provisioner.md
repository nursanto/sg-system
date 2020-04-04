# Deploy nfs provisioner

## Install nfs server
	apt install nfs-kernel-server
	mkdir -p /srv/nfs/kubedata
	chmod -R 777 /srv/nfs/
	cat  >>/etc/exports<<EOF
	/srv/nfs/kubedata       x.x.x.x/xx(rw,sync,no_subtree_check,insecure)
	EOF
	exportfs -a
	
	apt install nfs-common
	showmount x.x.x.x -e



cd nfs-provisioner
