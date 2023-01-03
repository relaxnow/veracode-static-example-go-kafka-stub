.PHONY: all consumer producer

ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

all: consumer producer

consumer:
	docker build -t consumer . --build-arg BUILD_TARGET=consumer	

producer:
	docker build -t producer . --build-arg BUILD_TARGET=producer

veracode:
	# Clean
	rm -rf /tmp/confluent-kafka-go-veracode-stub
	rm -rf /tmp/veracode-package-consumer
	rm -rf /tmp/veracode-package-producer
	
	# Set up stub in /tmp
	cd /tmp && git clone git@github.com:relaxnow/confluent-kafka-go-veracode-stub.git
	
	# Package consumer
	mkdir /tmp/veracode-package-consumer
	cp -Rf * /tmp/veracode-package-consumer
	cp -f veracode.consumer.json /tmp/veracode-package-consumer/veracode.json
	cat veracode.go.mod >> /tmp/veracode-package-consumer/go.mod
	cd /tmp/veracode-package-consumer && go mod vendor
	cd /tmp && zip -r veracode-package-consumer.zip veracode-package-consumer
	rm -rf /tmp/veracode-package-consumer
	
	# Package producer
	mkdir /tmp/veracode-package-producer
	cp -Rf * /tmp/veracode-package-producer
	cp -f veracode.producer.json /tmp/veracode-package-producer/veracode.json
	cat veracode.go.mod >> /tmp/veracode-package-producer/go.mod
	cd /tmp/veracode-package-producer && go mod vendor
	cd /tmp && zip -r veracode-package-producer.zip veracode-package-producer
	rm -rf /tmp/veracode-package-producer

	# Remove stub
	rm -rf /tmp/confluent-kafka-go-veracode-stub
	
	# Copy packages in veracode folder
	mkdir veracode
	mv /tmp/veracode-package-consumer.zip veracode
	mv /tmp/veracode-package-producer.zip veracode