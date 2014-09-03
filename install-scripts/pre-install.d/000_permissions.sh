#!/bin/bash -e

(
    cd ${SERVCONF_PATH}

    find .          -name '*.sh' -print0 | xargs -0 chmod u+x
    find bin        -type f      -print0 | xargs -0 chmod u+x

)
