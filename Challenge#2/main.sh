#!/bin/bash

get_instance_metadata() {
    local id=$(curl -ks http://$IP/latest/meta-data/instance-id)
    local av_zone=$(curl -ks http://$IP/latest/meta-data/placement/availability-zone)
    local instance_type=$(curl -ks http://$IP/latest/meta-data/instance-type)
    local pub_ip=$(curl -ks http://$IP/latest/meta-data/public-ipv4)
    local pri_ip=$(curl -ks http://$IP/latest/meta-data/local-ipv4)

    local json_metadata=$(cat <<EOF
{
  "InstanceId": "$id",
  "AvailabilityZone": "$av_zone",
  "InstanceType": "$instance_type",
  "PublicIpAddress": "$pub_ip",
  "PrivateIpAddress": "$pri_ip"
}
EOF
)

    echo "$json_metadata"
}

json_output=$(get_instance_metadata)
echo "$json_output"