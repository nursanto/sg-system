# WFH-2

## Kubernetes

|   Role   |         FQDN         |   IP Address  |    OS    |  RAM | CPU |  u/p   |
|----------|----------------------|---------------|----------|------|-----|--------|
|  Master  | kmaster.example.com  | 172.42.42.100 | CentOS 7 |  2G  |  2  | root/q |
|  Worker  | kworker1.example.com | 172.42.42.101 | CentOS 7 |  2G  |  1  | root/q |

### Create vm using vagrant
	git clone https://github.com/nursanto/sg-system.git
	cd sg-system/wfh-2/vagrant/
	vagrant status
	vagrant up
	vagrant status

### Install kubernetes

### a. Master Node
#### a.1 ssh to master node
	cat /dev/null > /root/.ssh/known_hosts
	ssh root@172.42.42.100

#### a.2 Update hosts file
	cat >>/etc/hosts<<EOF
	172.42.42.100 kmaster.example.com kmaster
	172.42.42.101 kworker1.example.com kworker1
    EOF

#### a.3 Install docker from Docker-ce repository
	yum install -y yum-utils device-mapper-persistent-data lvm2
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	yum install -y docker-ce

#### a.4 Enable docker service
	systemctl enable docker
	systemctl start docker
	systemctl status docker

#### a.5 Disable SELinux
	setenforce 0
	sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

#### a.6 Stop and disable firewalld
	systemctl disable firewalld
	systemctl stop firewalld

#### a.7 Add sysctl settings
	cat >>/etc/sysctl.d/kubernetes.conf<<EOF
	net.bridge.bridge-nf-call-ip6tables = 1
	net.bridge.bridge-nf-call-iptables = 1
	EOF
	sysctl --system

#### a.8 Disable swap
	sed -i '/swap/d' /etc/fstab
	swapoff -a

#### a.9 Add yum repo file for Kubernetes
	cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
	[kubernetes]
	name=Kubernetes
	baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
	enabled=1
	gpgcheck=1
	repo_gpgcheck=1
	gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
	        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
	EOF

#### a.10 Install Kubernetes
	yum install -y kubeadm kubelet kubectl

#### a.11 Start and Enable kubelet service
	systemctl enable kubelet
	systemctl start kubelet

#### a.12 Initialize Kubernetes
	kubeadm init --apiserver-advertise-address=172.42.42.100 --pod-network-cidr=192.168.0.0/16 >> /root/kubeinit.log

#### a.13 Copy Kube admin config
	mkdir /root/.kube
	cp /etc/kubernetes/admin.conf /root/.kube/config

#### a.14 Deploy calico network
	kubectl create -f https://docs.projectcalico.org/v3.9/manifests/calico.yaml

#### a.15 Generate Cluster join command
	kubeadm token create --print-join-command > joincluster.sh
	scp joincluster.sh root@kworker1:.
	exit


#### b. Worker Node
#### b.1 ssh to worker node
	ssh root@172.42.42.101

#### b.2 Update hosts file
	cat >>/etc/hosts<<EOF
	172.42.42.100 kmaster.example.com kmaster
	172.42.42.101 kworker1.example.com kworker1
    EOF

#### b.3 Install docker from Docker-ce repository
	yum install -y yum-utils device-mapper-persistent-data lvm2
	yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	yum install -y docker-ce

#### b.4 Enable docker service
	systemctl enable docker
	systemctl start docker
	systemctl status docker

#### b.5 Disable SELinux
	setenforce 0
	sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

#### b.6 Stop and disable firewalld
	systemctl disable firewalld
	systemctl stop firewalld

#### b.7 Add sysctl settings
	cat >>/etc/sysctl.d/kubernetes.conf<<EOF
	net.bridge.bridge-nf-call-ip6tables = 1
	net.bridge.bridge-nf-call-iptables = 1
	EOF
	sysctl --system

#### b.8 Disable swap
	sed -i '/swap/d' /etc/fstab
	swapoff -a

#### b.9 Add yum repo file for Kubernetes
	cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
	[kubernetes]
	name=Kubernetes
	baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
	enabled=1
	gpgcheck=1
	repo_gpgcheck=1
	gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
	        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
	EOF

#### b.10 Install Kubernetes
	yum install -y kubeadm kubelet kubectl

#### b.11 Start and Enable kubelet service
	systemctl enable kubelet
	systemctl start kubelet

#### b.12 Join worker nodes to the Kubernetes cluster
	chmod +x joincluster.sh
	./joincluster.sh
	exit

### c. Akses to kubernetes cluster
#### c.1 install kubernetes client
	cat >>/etc/hosts<<EOF
	172.42.42.100 kmaster.example.com kmaster
	172.42.42.101 kworker1.example.com kworker1
	EOF

	cat <<EOF > /etc/yum.repos.d/kubernetes.repo
	[kubernetes]
	name=Kubernetes
	baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
	enabled=1
	gpgcheck=1
	repo_gpgcheck=1
	gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
	EOF
	yum install -y kubectl

#### c.2 copy kubernetes credential
	cd ~/
	mkdir /root/.kube
	scp root@172.42.42.100:/etc/kubernetes/admin.conf /root/.kube/config

#### c.3 akses to kubernetes
	kubectl cluster-info
	kubectl run nginx --image nginx
	kubectl get all
	kubectl expose pod nginx --type NodePort --port 80
	kubectl get all
	curl kworker1:32647

### d. install haproxy
	yum -y install haproxy
	cat >>/etc/haproxy/haproxy.cfg<<EOF
	frontend nodeport
	  bind *:30000-32767
	  default_backend nodeport
	  mode tcp
	  option tcplog

	backend nodeport
	  balance roundrobin
	  server kworker1 172.42.42.101
	EOF

	systemctl restart haproxy
	systemctl enable haproxy
