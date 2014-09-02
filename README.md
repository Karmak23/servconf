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
- `SERVCONF_DONT_SYNC_SSH`: do not sync your local `~/.ssh` folder to `~/` on remote machines. As I use the same user account everywhere, this is usually a good thing for me to do it. But if you don't want this, just define this variable to any value.

### Other

Define `SERVCONF_DEBUG` to any value to get debug messages during execution (there are not many, yet).
