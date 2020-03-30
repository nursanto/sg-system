# WFH

### Install Docker
	yum install -y yum-utils device-mapper-persistent-data lvm2 
	yum-config-manager  --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
	yum install docker-ce
	systemctl start docker

### Menjalankan container
	docker run -it httpd bash
	docker run -it centos bash
	docker run -it centos cat /etc/centos-release
	docker run -it centos cat /etc/hosts

	docker run -dit httpd
	docker run -dit --name myweb httpd
	docker inspect myweb

	docker run -dit --name myweb -p 8080:80 httpd

	mkdir data
	chmod -R 755 data/
	cd data
	echo "hello world from external storage" > index.html
	docker run -dit --name my-apache-app -p 8080:80 -v "$PWD":/usr/local/apache2/htdocs/ httpd:2.4

### Dockerfile
	cd ~
	git clone https://github.com/nursanto/sg-system.git
	cd sg-system/wfh/materials/
	docker image build --tag myimage:v1 .
	docker images
	docker run -dit -p 8080:80 --name myimage myimage:v1


cheat:
for i in {1..9};do docker run -dit -p 808$i:80 httpd;done
for i in $(docker ps -aq);do docker rm -f $i;done
