#!/bin/bash -e

(
    cd ${SERVCONF_PATH}

    find .          -name '*.sh' -print0 | xargs -0 chmod u+x
    find cron.daily -type f      -print0 | xargs -0 chmod u+x
    find bin        -type f      -print0 | xargs -0 chmod u+x

    chown -R root: duply private
    chmod -R g-rwx,o-rwx duply private

)
