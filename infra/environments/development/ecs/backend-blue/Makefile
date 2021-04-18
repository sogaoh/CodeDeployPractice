.PHONY:

help:
	cat Makefile


CONF_OPT := --config config.yaml
DEPLOY_OPT := --skip-task-definition --latest-task-definition
APPSPEC_OPT := current

verify:
	ecspresso $(CONF_OPT) verify

dry-create:
	ecspresso $(CONF_OPT) create --dry-run

create:
	ecspresso $(CONF_OPT) create

status:
	ecspresso $(CONF_OPT) status

diff:
	ecspresso $(CONF_OPT) diff

tasks:
	ecspresso $(CONF_OPT) tasks


dry-register:
	ecspresso $(CONF_OPT) register --dry-run

register:
	ecspresso $(CONF_OPT) register


dry-deploy:
	ecspresso $(CONF_OPT) deploy --dry-run $(DEPLOY_OPT)

deploy:
	ecspresso $(CONF_OPT) deploy $(DEPLOY_OPT) --no-wait
	#ecspresso $(CONF_OPT) wait

appspec:
	ecspresso $(CONF_OPT) appspec --task-definition=$(APPSPEC_OPT)


#rollback:
#	ecspresso $(CONF_OPT) rollback --deregister-task-definition
#
#dry-rollback:
#	ecspresso $(CONF_OPT) rollback --dry-run
#
#soft-rollback:
#	ecspresso $(CONF_OPT) rollback


scale1:
	ecspresso $(CONF_OPT) scale --tasks=1
scale0:
	ecspresso $(CONF_OPT) scale --tasks=0
