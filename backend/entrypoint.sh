#!/bin/sh
set -ex

# a real backend app would put their script name here
expected=tail

# this if will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; etc will work, but not arg1 arg2
if [ "${1:0:1}" = '-' ]; then
    set -- "$expected" "$@"
fi

# put everything through Tor if possible
if [ -n "$TOR_HOSTNAME" ] || [ -n "$TOR_IP" ]; then
    # torsocks does not support name resolution so we do it here
    TORSOCKS_CONF_FILE=/etc/tor/torsocks.conf

    until [ -n "$TOR_IP" ]; do
        TOR_IP=$(getent hosts "$TOR_HOSTNAME" | cut -f1 -d' ')

        # TODO: max wait?
        if [ -z "$TOR_IP" ]; then
            echo "Tor is not yet running at $TOR_HOSTNAME! Sleeping..."
            sleep 10
        fi
    done

    echo "TorAddress $TOR_IP" > "$TORSOCKS_CONF_FILE"

    # torify everything
    export TORSOCKS_CONF_FILE
    export LD_PRELOAD=/usr/lib/torsocks/libtorsocks.so
fi

# check for the expected command
if [ "$1" = "$expected" ] && [ "$3" = "/dev/null" ]; then
    # a real backend app would do some setup here
    echo "Welcome!"

    exec "$@"
fi

# else default to run whatever the user wanted like "bash"
exec "$@"
