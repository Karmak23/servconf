#!/bin/bash -e

#
# NOTE: this script only installs the agent.
# Shipyard should be installed elsewhere.
#

if has_line etc/init/shipyard ${HOST_INSTALL_FILE}; then

	if [[ -z "docker ps | grep shipyard" ]]; then

		sed -i /etc/default/docker -e 's%^.*DOCKER_OPTS=.*%DOCKER_OPTS="-H tcp://127.0.0.1:4243 -H unix://var/run/docker.sock"%'

		restart docker || start docker || true

		docker run -i -t -v /var/run/docker.sock:/docker.sock shipyard/deploy setup
	fi

	if [[ ! -x /usr/local/bin/shipyard-agent ]]; then

		curl https://github.com/shipyard/shipyard-agent/releases/download/0.1.0/shipyard-agent \
			-L -o /usr/local/bin/shipyard-agent

		chmod 755 /usr/local/bin/shipyard-agent

	fi

	if [[ -z "`ps ax | grep shipyard-agent`" ]]; then

		initctl reload-configuration || true

		#start shipyard || restart shipyard || true


		install_message "Please run: "
		install_message "shipyard-agent -url http://localhost:8000 -register"
		install_message "Go to `hostname`:8000 > Hosts > Authorize host"
		install_message "shipyard-agent -url http://localhost:8000 -key …"

	fi

fi
