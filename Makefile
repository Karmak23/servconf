
all: install

git_update:
	@echo "global-config update in $${PWD} for $${USER}"
	@sudo chown -R $${USER} .
	@git reset --hard
	@git up || git pull

# In case we need duply/*, it's -path {0}/duply/*
install:
	@sudo bash install.sh $${USER}

update: git_update install

# one target for all, to allow any command to fail
# and correctly feeback Fabric with the failed status.
remote_update:
	@make git_update
	@make install
