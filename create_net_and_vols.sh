#!/bin/sh

# Creates external widget mongodb container data volumes and overlay network

set -e

docker-machine env manager1
eval $(docker-machine env manager1)

# create overlay network for stack
docker network create \
  --driver overlay \
  --subnet=10.0.0.0/16 \
  --ip-range=10.0.11.0/24 \
  --opt encrypted \
  --attachable=true \
  widget_overlay_net

echo "Network completed..."

# create data volumes for MongoDB
vms=( "manager1" "manager2" "manager3"
      "worker1" "worker2" "worker3" )

for vm in "${vms[@]:3:3}"
do
  docker-machine env ${vm}
  eval $(docker-machine env ${vm})
  docker volume create --name=widget_data_vol
  echo "Volume created: ${vm}..."
done

echo "Script completed..."
