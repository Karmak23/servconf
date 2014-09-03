servconf
========

Physical servers and containers (LXC) configuration/deployment tools for Ubuntu LTS & Debian. Shell & python based. Minimalist design. Tested and used daily on Ubuntu LTS 12.04 and 14.04.

Once your machine is up for the first time (eg. OS installation finished) and you have a bare user account on it, `servconf` will help you automate setting up useful things on a server:
- a simple and easily customizable firewall (default open ports: 22, 80, 443),
- a restricted SSH configuration (*pubkeys* and members of `remotessh` group only, `fail2ban` coming soon),
- LXC tools for easy container management,
- unattended-upgrades already configured and running,
- `duply`, a remote encrypted/incremental backup solution (that you need to configure),
- a full git/virtualenv/build environment,
- and some other minor goodies.

`servconf` also embeds already setup and up-to-date configuration files for various services, that you can choose to install or not on your machines. You can easily customize them by machine or groups of machines.

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

I strongly advise you to have a test machine and run `fab test` on it before; because `servconf` can cut your SSH access if you misconfigure it properly (default configuration should keep you connected, and it didn't fail recently). If you have physical or rescue access, don't bother.

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

# License

GNU GPLv3.
