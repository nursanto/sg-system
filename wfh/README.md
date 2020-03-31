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

### Dockerfile-1
	cd ~
	git clone https://github.com/nursanto/sg-system.git
	cd sg-system/wfh/materials/Dockerfile-1
	docker image build --tag myimage:v1 .
	docker images
	docker run -dit -p 8080:80 --name myimage myimage:v1

### Dockerfile-2
	cd ~
	cd sg-system/wfh/materials/Dockerfile-2
	docker image build --tag myimage:v2 .
	docker images
	docker run -dit -p 8081:80 --name myimage myimage:v2

### Docker registry docker hub
	docker tag myimage:v1 nursanto/myimage:1.0
	docker tag myimage:v2 nursanto/myimage:2.0
	docker images
	docker login
	docker push nursanto/myimage:1.0
	docker push nursanto/myimage:2.0

### 

#### cheat:
	# buat 9 container sekaligus
	for i in {1..9};do docker run -dit -p 808$i:80 httpd;done
	# hapus paksa semua container yg mati dan jalan
	for i in $(docker ps -aq);do docker rm -f $i;done
