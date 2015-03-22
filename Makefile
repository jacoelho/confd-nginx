NAME =  jacoelho/confd-nginx
TAG = dev

.PHONY: build

all: build

build:
	docker build --rm -t $(NAME):$(TAG) .
