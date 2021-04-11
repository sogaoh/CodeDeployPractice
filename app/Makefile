.PHONY:

help:
	cat Makefile

PRODUCT_NAME := codedeploy-practice

IMG_TAG := latest

BLDARG_TZ := --build-arg TZ=Asia/Tokyo

AWS_ACCOUNT_ID :=
AWS_REGION := ap-northeast-1


# build
build:
	docker build --no-cache -t $(PRODUCT_NAME)/maintenance:latest -f ./ship/docker/maintenance-html/Dockerfile $(BLDARG_TZ) .

# tag
tag:
	docker tag $(PRODUCT_NAME)/maintenance:latest "$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PRODUCT_NAME)/maintenance:latest"

# ecr login
ecr-login:
	aws ecr get-login-password --region ${AWS_DEFAULT_REGION} --profile ${AWS_DEFAULT_PROFILE} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com

# push
push:
	docker push "$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PRODUCT_NAME)/maintenance:latest"

# run
run:
	docker run -it $$(docker images | grep $(PRODUCT_NAME)/maintenance | grep latest | awk '{print $$3}') ash


# up/down
up:
	docker-compose up -d
upb:
	docker-compose up -d --build
down:
	docker-compose down --remove-orphans
prune:
	docker system prune --volumes
restart:
	@make down
	@make up
