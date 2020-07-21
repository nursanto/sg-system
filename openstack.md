# install packstack

## install packstack online
	yum -y update
	yum -y install vim tmux

	vi /etc/hosts
	echo -e "LANG=en_US.utf-8 \nLC_ALL=en_US.utf-8" > /etc/environment
	yum -y update
	systemctl disable firewalld
	systemctl stop firewalld
	systemctl disable NetworkManager
	systemctl stop NetworkManager
	systemctl enable network
	systemctl start network
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	yum install -y centos-release-openstack-stein
	yum update -y
	yum install -y openstack-packstack
	packstack --gen-answer-file=answerfile.txt
	reboot

	vim answerfile.txt
		CONFIG_PROVISION_DEMO=n     							# disable provisioning demo
		CONFIG_HEAT_INSTALL=y       							# enable heat
		CONFIG_NEUTRON_OVS_BRIDGE_IFACES=br-ex:ens160			# ganti ens160 dg nama interface
		CONFIG_NEUTRON_L2_AGENT=openvswitch						# ganti dr ovn ke openvswitch
		CONFIG_NEUTRON_ML2_TYPE_DRIVERS=vxlan,flat
		CONFIG_NEUTRON_ML2_TENANT_NETWORK_TYPES=vxlan
		CONFIG_NEUTRON_ML2_MECHANISM_DRIVERS=openvswitch
		CONFIG_DEFAULT_PASSWORD=admin							# default password

		
	tmux
	time packstack --answer-file=answerfile.txt | tee progres


#### referensi
https://keithtenzer.com/2019/10/28/openstack-15-stein-lab-installation-and-configuration-guide-for-hetzner-root-servers/


## install pacstack offline
## ofline repo
	[base]
	name=CentOS-$releasever - Base
	baseurl=ftp://192.168.26.43/pub/repos/base/
	enabled=1
	gpgcheck=0
	gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

	[updates]
	name=CentOS-$releasever - Updates
	baseurl=ftp://192.168.26.43/pub/repos/updates/
	enabled=1
	gpgcheck=0
	gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

	[extras]
	name=CentOS-$releasever - Extras
	baseurl=ftp://192.168.26.43/pub/repos/extras/
	enabled=1
	gpgcheck=0
	gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

	[centos-ceph-nautilus]
	name=CentOS-$releasever - centos-ceph-nautilus
	baseurl=ftp://192.168.26.43/pub/repos/centos-ceph-nautilus/
	enabled=1
	gpgcheck=0
	gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

	[centos-nfs-ganesha28]
	name=CentOS-$releasever - centos-nfs-ganesha28
	baseurl=ftp://192.168.26.43/pub/repos/centos-nfs-ganesha28/
	enabled=1
	gpgcheck=0
	gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

	[centos-openstack-stein]
	name=CentOS-$releasever - centos-openstack-stein
	baseurl=ftp://192.168.26.43/pub/repos/centos-openstack-stein/
	enabled=1
	gpgcheck=0
	gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

	[centos-qemu-ev]
	name=CentOS-$releasever - centos-qemu-ev
	baseurl=ftp://192.168.26.43/pub/repos/centos-qemu-ev/
	enabled=1
	gpgcheck=0
	gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7


## installasi
yum -y update
yum -y install vim tmux

vi /etc/hosts
echo -e "LANG=en_US.utf-8 \nLC_ALL=en_US.utf-8" > /etc/environment
yum -y update
systemctl disable firewalld
systemctl stop firewalld
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl enable network
systemctl start network
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
yum update -y
yum install -y openstack-packstack
packstack --gen-answer-file=answerfile.txt
reboot

vim answerfile.txt
	CONFIG_PROVISION_DEMO=n     							#1185 disable provisioning demo
	CONFIG_HEAT_INSTALL=y       							#60 enable heat
	CONFIG_NEUTRON_OVS_BRIDGE_IFACES=br-ex:ens160			#873 ganti ens160 dg nama interface
	CONFIG_NEUTRON_L2_AGENT=openvswitch						#844 ganti dr ovn ke openvswitch
	CONFIG_NEUTRON_ML2_TYPE_DRIVERS=vxlan,flat,vxlan		#799
	CONFIG_NEUTRON_ML2_TENANT_NETWORK_TYPES=vxlan			#805
	CONFIG_NEUTRON_ML2_MECHANISM_DRIVERS=openvswitch		#812
 	CONFIG_KEYSTONE_ADMIN_PW=								#326 default admin password 

	
tmux
time packstack --answer-file=answerfile.txt | tee progres

openstack network create mynetwork
openstack subnet create mysubnet --network mynetwork --subnet-range 10.10.10.0/24 --dns-nameserver 8.8.8.8
openstack server create --image cirros --flavor m1.tiny --network mynetwork myinstance

/etc/sysconfig/network-scripts/ifcfg-br-ex


