
all: install

git_update:
	@echo "servconf update in $${PWD} for $${USER}"
	@sudo chown -R $${USER} .
	@git reset --hard
	@git up || git pull
	@echo "private-data update in $${PWD} for $${USER}"
	@[ -d private-data ] && (cd private-data; git reset --hard; git pull)

# In case we need duply/*, it's -path {0}/duply/*
install:
	@sudo bash install.sh $${USER}

update: git_update install

# one target for all, to allow any command to fail
# and correctly feeback Fabric with the failed status.
remote_update:
	@make git_update
	@make install
