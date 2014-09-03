# -*- coding: utf-8 -*-
from __future__ import print_function

import os
import datetime
import itertools

from fabric.api              import task, execute, run, local, sudo
from fabric.contrib.files    import exists  # contains, append, sed
from fabric.context_managers import cd

# Use this in case paramiko seems to go crazy. Trust me, it can do, especially
# when using the multiprocessing module.
#
# import logging
# logging.basicConfig(format=
#                     '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
#                     level=logging.INFO)

# import the main fabfile to benefit from `env` defaults.
import sparks.fabric.fabfile as tasks

# import django tasks to hae them handy
import sparks.django.fabfile as django # NOQA

test_server  = os.environ.get('SERVCONF_TEST_SERVER')
servers     = os.environ.get('SERVCONF_SERVERS', '').split()
groups       = {}

for key in os.environ.get('SERVCONF_GROUPS', '').split():
    groups[key] = os.environ['SERVCONF_GROUP_' + key]

all_machines = servers + list(itertools.chain(groups.values()))

# Get the already setup Fabric env.
env = tasks.env
#env.parallel = True

env.roledefs.update({
    'all-machines': all_machines,
    'all': all_machines,
    'servers': servers,
})

LOCAL_HOME_DIR    = os.environ.get('HOME', os.path.expanduser('~'))
REMOTE_CONFIG_DIR = os.environ.get('SERVCONF_INSTALL_DIR', '/home/servconf')
MASTER_REPOSITORY = os.environ.get('SERVCONF_BIN_REPOSITORY',
                                   'https://github.com/Karmak23/servconf')
CONFIG_REPOSITORY = os.environ.get('SERVCONF_DATA_REPOSITORY', None)


@task
def all():
    env.roles = ('all', )


@task
def test_mail(email_address=None):

    if email_address is None:
        email_address = 'olive@licorn.org'

    test_date = datetime.datetime.now().isoformat()

    run('echo test | sudo mail -s "test {0}=?`hostname` {1}" {2}'.format(
        env.host_string, test_date, email_address))


@task
def sys_setup_server():

    tasks.base(upgrade=False)
    tasks.lxc_server() # this one will do nothing inside LXCs
    tasks.dev()


@task
def update_remote_configuration():

    if not exists('Dropbox'):
        if os.environ.get('SERVCONF_SYNC_DOT_SSH', False):
            local('rsync -aL ~/.ssh/ {0}:.ssh'.format(env.host_string))

        elif not os.environ.get('SERVCONF_DONT_SYNC_SSH_AT_ALL', False):
            local('scp ~/.ssh/config {0}:.ssh/'.format(env.host_string))

        local('rsync -aL ~/.bashrc {0}:'.format(env.host_string))
        local('rsync -aL ~/.gitconfig {0}:'.format(env.host_string))

    # Be sure we can ssh from the remote machine. This is annoying.
    run('chmod 700 .ssh; chmod 600 .ssh/*', quiet=True)

    tasks.sys_easy_sudo()
    tasks.sys_admin_pkgs()      # we need setfacl
    tasks.dev_mini()            # and git

    sys_setup_server()

    # We use run() because sudo('echo $USER')
    # gives 'root' (which is logical…)
    run('sudo addgroup -quiet --system admins; '
        'sudo adduser --quiet $USER admins')

    sudo('mkdir -p /home/users /home/backup /home/archives; '
         'chgrp admins /home/users /home/backup /home/archives; '
         'chmod g+rwx /home/users /home/backup /home/archives')
    #sudo('setfacl -m g:admins:rwx /home/users /home/backup /home/archives')

    c_dirname, c_basename = REMOTE_CONFIG_DIR.rsplit(os.sep, 1)

    if not exists(REMOTE_CONFIG_DIR):
        if not exists(c_dirname):
            sudo('mkdir "{0}"'.format(c_dirname))

        sudo('chgrp admins {0}; chmod g+rwx {0}'.format(c_dirname))
        #sudo('setfacl -m g:admins:rwx {0}'.format(c_dirname),
        #     warn_only=True)

        with cd(c_dirname):
            run('git clone {0} {1}'.format(MASTER_REPOSITORY, c_basename))

    with cd(REMOTE_CONFIG_DIR):
        if CONFIG_REPOSITORY is not None and not exists(
                    os.path.join(REMOTE_CONFIG_DIR, 'private-data')):
            run('git clone {0} {1}'.format(CONFIG_REPOSITORY,
                'private-data'))

        run("make remote_update")


@task
def test():
    local('git upa')
    execute(update_remote_configuration, hosts=(test_server, ))


@task(aliases=('gcs', 'go', 'sync'))
def global_config_sync(do_test=False):

    if do_test:
        # First, test it on gurney, on which I have
        # servers access if anything goes wrong ;-)
        test()
    else:
        local('git upa || git up')

    if env.host_string:
        # Allow to deploy manually on only one host at a time from CLI.
        all_others = [env.host_string]
    else:
        all_others = servers[:]

    if do_test and test_server in all_others:
        all_others.remove(test_server)

    execute(update_remote_configuration, hosts=all_others)
