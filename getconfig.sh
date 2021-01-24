#!/bin/bash
if [ -z ${1} ]; then
    echo "Issue follwing command to get default configure."
    echo "This command will overwrite existing files!"
    folder=${PWD##*/}
    echo ${0} ${folder}_radius
    exit;
fi

#copy defualt configure
docker inspect $(docker images -q ${1}) >/dev/null 2>&1
if [ $? -eq 0 ]; then
    
    #docker run --rm -i ${1} /bin/bash -c 'cat /etc/freeradius/3.0/sites-available/inner-tunnel' |grep -v '^#'|sed '/^$/d' > inner-tunnel
    #docker run --rm -i ${1} /bin/bash -c 'cat /etc/freeradius/3.0/radiusd.conf'  > radiusd.conf
    #docker run --rm -i ${1} /bin/bash -c 'cat /etc/freeradius/3.0/mods-available/eap' |grep -v '#'|sed '/^$/d' > eap
    docker run --rm -i ${1} /bin/bash -c 'cat /etc/freeradius/3.0/mods-available/sql' |grep -v '#'|sed '/^$/d' > sql
    docker run --rm -i ${1} /bin/bash -c 'cat /etc/freeradius/3.0/clients.conf' |grep -v '#'|sed '/^$/d' > clients.conf
    echo "done"
else
    echo The ${1} image is not found.
    echo "Issue follwing command to build an image."
    echo "docker-compose build"
fi
