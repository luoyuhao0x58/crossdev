#! /bin/bash
set -ueo pipefail

keys=($(grep 'HostKey ' /etc/ssh/sshd_config | cut -d' ' -f2))

for key in ${keys[@]}
do
    if [ ! -f "$key" ]; then
        t=$(echo "$key" | cut -d'_' -f3)
        if [[ $t == "rsa" ]]; then
            ssh-keygen -q -N "" -t $t -b 4096 -f $key
        else
            ssh-keygen -q -N "" -t $t -f $key
        fi
        echo "Generated $key"
    fi
done

exec /usr/sbin/sshd -D