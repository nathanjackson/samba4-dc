#!/bin/sh

# Check if we should run Samba or pass args to it.
args=""
if [ "${1:0:1}" = '-' ]; then
    args=$@
elif [ $# -gt 0 ]; then
    exec "$@"
    exit $?
fi

# Check if we should provision a domain.
if ! [ -e /provisioned ] &&
     [ "$PROVISION" != "false" ]; then

    # Check required inputs.
    if [ -z ${REALM+x} ]; then
        echo error: REALM environment variable must be set.
        exit 1
    fi
    if [ -z ${ADMINPASS+x} ]; then
        echo error: ADMINPASS environment variable must be set.
        exit 1
    fi
    if [ -z ${DOMAIN+x} ]; then
        echo error: DOMAIN environment variable must be set.
        exit 1
    fi

    echo Provisioning Active Directory Domain...

    # Provision the domain.
    samba-tool domain provision \
        --realm=$REALM          \
        --adminpass=$ADMINPASS  \
        --domain=$DOMAIN        \
        --use-rfc2307

    # Symlink Kerberos configuration.
    ln -s /var/lib/samba/private/krb5.conf /etc/krb5.conf

    # This is used to check if we need to provision a domain.
    touch /provisioned
fi

echo Starting Active Directory Domain Controller...
eval "samba -i $args < /dev/null"
