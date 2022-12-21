#!/bin/bash

set -x

cd /data

if ! [[ -f serverinstall_100_2308 ]]; then
	rm -fr config defaultconfigs kubejs libraries log4jfix mods resourcepacks minecraft-server-1.18.2.jar version.json start.sh run.* user_jvm_args.txt serverinstall_100_*
	mv /serverinstall_100_2287 /data/serverinstall_100_2308
	./serverinstall_100_2308 -auto
fi

if ! [[ -f server-icon.png ]]; then
	mv /stoneblock-3.png /data/server-icon.png
fi

if ! [[ "$EULA" = "false" ]] || grep -i true eula.txt; then
	echo "eula=true" > eula.txt
else
	echo "You must accept the EULA by in the container settings."
	exit 9
fi

if [[ -n "$MOTD" ]]; then
    sed -i "/motd\s*=/ c motd=$MOTD" server.properties
fi
if [[ -n "$LEVEL" ]]; then
    sed -i "/level-name\s*=/ c level-name=$LEVEL" server.properties
fi
if [[ -n "$LEVELTYPE" ]]; then
    sed -i "/level-type\s*=/ c level-type=$LEVELTYPE" server.properties
fi

echo "$JVM_OPTS" > user_jvm_args.txt

if [[ -n "$OPS" ]]; then
    echo $OPS | awk -v RS=, '{print}' >> ops.txt
fi

./start.sh
