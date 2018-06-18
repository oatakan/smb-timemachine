#!/bin/bash

set -e

if [ ! -z $SMB_LOGIN ] && [ ! -z $SMB_PASSWORD ] && [ ! id -u $SMB_LOGIN > /dev/null 2>&1 ]; then
    if [ ! -z $SMB_UID ] && [ ! -z $SMB_GID ]; then
        adduser --disabled-password --gecos $SMB_LOGIN --uid $SMB_UID --gid $SMB_GID $SMB_LOGIN
    else
        adduser --disabled-password --gecos $SMB_LOGIN $SMB_LOGIN
    fi
    smbpasswd -L -a -n $SMB_LOGIN
    smbpasswd -L -e -n $SMB_LOGIN

    echo -e "$SMB_PASSWORD\n$SMB_PASSWORD" | smbpasswd -L -s $SMB_LOGIN

    sed -i -e "s/timemachine/${SMB_LOGIN}/g" /etc/fix-attrs.d/01-time-capsule-dir
    sed -i -e "s/timemachine/${SMB_LOGIN}/g" /etc/samba/smb.conf

fi

/init