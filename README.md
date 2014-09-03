servconf
========

Physical servers and containers (LXC) configuration/deployment tools for Ubuntu LTS & Debian.

Tested and daily used on Ubuntu LTS 12.04 and 14.04.


# Documentation


## Installation

You need [sparks](https://github.com/1flow/sparks), which will install [my patched version of Fabric](https://github.com/Karmak23/fabric).

	pip install -e git+https://github.com/1flow/sparks@master#egg=sparks


## Usage

- create an *environment* configuration file for your machine(s). You can group them to apply common bits of configuration. **MORE TO COME**
- source your configuration file in your current shell.
- deploy with `fab sync`.

I strongly advise you to have a test machine and run `fab test` on it before; because `servconf` can cut your SSH access if you don't configure it properly.

## Variables

### Custom configuration

- `SERVCONF_FIREWALL_DISABLE_LXC_100TO150`: disable the conventional LXC SSH port opening for `10.0.3.100→150:22` to `$MAIN_IP:22100→150`.
- `SERVCONF_SYNC_DOT_SSH`: sync your whole local `~/.ssh` folder to `~/` on remote machines. If you use the same user account everywhere, this could be comfortable to do it. I usually do it on my own network, but not on my customers'. Define to any value to set. Note: if set, only the `~/.ssh/config` file is synched, which is usually sufficient. If you don't even want that, see next variable.
- `SERVCONF_DONT_SYNC_SSH_AT_ALL`: pretty straightforward, isn't it ? Define to any value to work.

### Other

Define `SERVCONF_DEBUG` to any value to get debug messages during execution (there are not many, yet).
