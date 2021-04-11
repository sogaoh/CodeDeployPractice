.PHONY:

help:
	cat Makefile


CONF_OPT := --config config.yaml


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


dry-deploy:
	ecspresso $(CONF_OPT) deploy --dry-run

deploy:
	ecspresso $(CONF_OPT) deploy

rollback:
	ecspresso $(CONF_OPT) rollback --deregister-task-definition

dry-rollback:
	ecspresso $(CONF_OPT) rollback --dry-run

soft-rollback:
	ecspresso $(CONF_OPT) rollback


scale1:
	ecspresso $(CONF_OPT) scale --tasks=1
scale0:
	ecspresso $(CONF_OPT) scale --tasks=0
