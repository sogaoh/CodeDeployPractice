.PHONY:

help:
	cat Makefile

PRODUCT_NAME := codedeploy-practice

IMG_TAG := latest

BLDARG_TZ := --build-arg TZ=Asia/Tokyo
BLDARG_BG_BLUE  := --build-arg BG_SIDE=blue
BLDARG_BG_GREEN := --build-arg BG_SIDE=green

AWS_ACCOUNT_ID :=
AWS_REGION := ap-northeast-1


# build
build: build-b build-g
build-b:
	docker build --no-cache -t $(PRODUCT_NAME)/maintenance:blue  -f ./ship/docker/maintenance-blue-html/Dockerfile $(BLDARG_TZ) $(BLDARG_BG_BLUE) .
build-g:
	docker build --no-cache -t $(PRODUCT_NAME)/maintenance:green -f ./ship/docker/maintenance-green-html/Dockerfile $(BLDARG_TZ) $(BLDARG_BG_GREEN) .

# tag
tag: tag-b tag-g
tag-b:
	docker tag $(PRODUCT_NAME)/maintenance:blue  "$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PRODUCT_NAME)/maintenance:blue"
tag-g:
	docker tag $(PRODUCT_NAME)/maintenance:green "$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PRODUCT_NAME)/maintenance:green"

# ecr login
ecr-login:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

# push
push: push-b push-g
push-b:
	docker push "$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PRODUCT_NAME)/maintenance:blue"
push-g:
	docker push "$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(PRODUCT_NAME)/maintenance:green"

# run
run-blue:
	docker run -it $$(docker images | grep $(PRODUCT_NAME)/maintenance | grep blue  | awk '{print $$3}') ash
run-green:
	docker run -it $$(docker images | grep $(PRODUCT_NAME)/maintenance | grep green | awk '{print $$3}') ash


# blue
blue1: build-b tag-b
blue2: ecr-login push-b

# green
green1: build-g tag-g
green2: ecr-login push-g


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
