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

define `SERVCONF_DEBUG` to anything to get debug messages (there are not many, yet).
