servconf
========

Physical servers and containers (LXC) configuration/deployment tools for Ubuntu LTS & Debian.

Tested and daily used on Ubuntu LTS 12.04 and 14.04.


# Documentation


## Installation

You need [sparks](https://github.com/1flow/sparks), which will install [my patched version of Fabric](https://github.com/Karmak23/fabric).

	mkvirtualenv servconf
	pip install -e git+https://github.com/1flow/sparks@master#egg=sparks


## Usage

- create an *environment* configuration file for your machine(s). You can group them to apply common bits of configuration. The minimal content is:

    export SERVCONF_TEST_SERVER="test-server.example.com"
    export SERVCONF_SERVERS="myserver.example.com"

- source your configuration file in your current shell.
- deploy with `fab sync`.

This will setup the machine with:
- a default firewall (open ports: 22, 80, 443),
- a restricted SSH configuration (pubkeys and members of `remotessh` group only),
- LXC tools for easy container management,
- unattended-upgrades already configured,
- a full git/virtualenv/build environment,
- `duply`, a remote encrypted/incremental backup solution (that you need to configure),
- and some other goodies.

I strongly advise you to have a test machine and run `fab test` on it before; because `servconf` can cut your SSH access if you don't configure it properly.

## Advanced usage & customization

`servconf` provides generic but useful configuration files (eg. already setup for LXC). But you need to tweak or define some other which are dependant on your configuration (eg. backup storage location). After that, syncing/deploying a new server is a matter of:

	cd my-servconf-data-repository
	source servenv.conf
    pushd ../servconf ; fab sync; popd

And the directory structure of `my-servconf-data-repository` is:

	my-servconf-data-repository
		.git/                               (required)
		servconf.env 						(required)
		machines/                           (see below)
			myserver.example.com/
				install 					(required)
				etc/
					duply/
						conf
				firewall/					(optional)
					variables 				(optional)
					body 					(optional)
		etc/								(see below)
			…

Explanations: to come.

## Variables


### Custom configuration

- `SERVCONF_FIREWALL_DISABLE_LXC_100TO150`: disable the conventional LXC SSH port opening for `10.0.3.100→150:22` to `$MAIN_IP:22100→150`.
- `SERVCONF_SYNC_DOT_SSH`: sync your whole local `~/.ssh` folder to `~/` on remote machines. If you use the same user account everywhere, this could be comfortable to do it. I usually do it on my own network, but not on my customers'. Define to any value to set. Note: if set, only the `~/.ssh/config` file is synched, which is usually sufficient. If you don't even want that, see next variable.
- `SERVCONF_DONT_SYNC_SSH_AT_ALL`: pretty straightforward, isn't it ? Define to any value to work.

### Other

Define `SERVCONF_DEBUG` to any value to get debug messages during execution (there are not many, yet).
