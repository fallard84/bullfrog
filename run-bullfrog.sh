#!/bin/sh

PHASE=$1

docker run -d --rm --privileged --net=host --name inner1 -v /:/mnt ubuntu bash -c "sleep 300"
docker cp /action inner1:/mnt

if [ "$PHASE" = "main" ]; then
    docker exec inner1 sh -c "chroot /mnt bash -c \"sudo env INPUT_EGRESS-POLICY=audit INPUT_DNS-POLICY=allowed-domains-only INPUT__AGENT-DOWNLOAD-BASE-URL=https://github.com/bullfrogsec/bullfrog/releases/download/ INPUT__LOG-DIRECTORY=/tmp/gha-agent/logs INPUT_ENABLE-SUDO=true node /action/action/dist/main.js\""
elif [ "$PHASE" = "post" ]; then
    docker exec inner1 sh -c "chroot /mnt bash -c \"sudo env INPUT_EGRESS-POLICY=audit INPUT_DNS-POLICY=allowed-domains-only INPUT__AGENT-DOWNLOAD-BASE-URL=https://github.com/bullfrogsec/bullfrog/releases/download/ INPUT__LOG-DIRECTORY=/tmp/gha-agent/logs INPUT_ENABLE-SUDO=true node /action/action/dist/post.js\""
else 
    echo "Invalid phase"
fi
docker kill inner1