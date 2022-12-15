.PHONY: all consumer producer

all: consumer producer

consumer:
	docker build -t consumer . --build-arg BUILD_TARGET=consumer	

producer:
	docker build -t producer . --build-arg BUILD_TARGET=producer
