# WFH

## Docker

### 1. Install Docker
	yum install -y yum-utils device-mapper-persistent-data lvm2 
	yum-config-manager  --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
	yum -y install docker-ce
	systemctl start docker

### 2. Menjalankan container
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

### 3. Dockerfile-1
	cd ~
	git clone https://github.com/nursanto/sg-system.git
	cd sg-system/wfh-1/materials/Dockerfile-1
	docker image build --tag myimage:v1 .
	docker images
	docker run -dit -p 8081:80 --name myimage myimage:v1

### 4. Dockerfile-2
	cd ~
	cd sg-system/wfh-1/materials/Dockerfile-2
	docker image build --tag myimage:v2 .
	docker images
	docker run -dit -p 8082:80 --name myimage myimage:v2

### 5. Docker registry docker hub
	docker tag myimage:v1 nursanto/myimage:v1
	docker tag myimage:v2 nursanto/myimage:v2
	docker images
	docker login
	docker push nursanto/myimage:v1
	docker push nursanto/myimage:v2

	docker run -dit -p 8081:80 --name myimage-1 nursanto/myimage:v1
	docker run -dit -p 8082:80 --name myimage-2 nursanto/myimage:v2

### 6. Docker compose
	curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose 
	chmod +x /usr/local/bin/docker-compose 
	ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose 
	docker-compose --version 

	cd ~
	cd sg-system/wfh-1/materials/docker-compose
	docker-compose up -d

#### cheat:
	# buat 9 container sekaligus
	for i in {1..9};do docker run -dit -p 808$i:80 httpd;done

	# hapus paksa semua container yg mati dan jalan
	for i in $(docker ps -aq);do docker rm -f $i;done

	# hapus semua image
	for i in $(docker images -q);do docker rmi $i;done	

