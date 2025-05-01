#!/bin/bash

ANSIBLE_HOSTS="./hosts"

port_1=$(curl -s "http://public_ip/random_url.html" | grep swmando-1 | grep -oP 'ubuntu@\d+\.\d+\.\d+\.\d+ port \K\d+')
port_2=$(curl -s "http://public_ip/random_url.html" | grep swmando-2 | grep -oP 'ubuntu@\d+\.\d+\.\d+\.\d+ port \K\d+')
port_3=$(curl -s "http://public_ip/random_url.html" | grep swmando-3 | grep -oP 'ubuntu@\d+\.\d+\.\d+\.\d+ port \K\d+')

# Check if port_1 was extracted successfully
if [[ -z "$port_1" ]]; then
    echo "Failed to extract port_1."
    exit 1
fi

# Check if port_2 was extracted successfully
if [[ -z "$port_2" ]]; then
    echo "Failed to extract port_2."
    exit 1
fi

# Check if port_2 was extracted successfully
if [[ -z "$port_3" ]]; then
    echo "Failed to extract port_3."
    exit 1
fi

# Update the Ansible hosts file by replacing the existing port for swmando-1
# Adjust the sed command to update only the port number
if grep -q "swmando-1" "$ANSIBLE_HOSTS"; then
    # Update existing entry
    sed -i "s/\(swmando-1.*ansible_port=\)[0-9]*/\1$port_1/" "$ANSIBLE_HOSTS"
    echo "Updated swmando-1 in hosts file with ansible_port=$port_1."
else
    echo "swmando-1 entry not found in hosts file."
    exit 1
fi


if grep -q "swmando-2" "$ANSIBLE_HOSTS"; then
    # Update existing entry
    sed -i "s/\(swmando-2.*ansible_port=\)[0-9]*/\1$port_2/" "$ANSIBLE_HOSTS"
    echo "Updated swmando-2 in hosts file with ansible_port=$port_2."
else
    echo "swmando-2 entry not found in hosts file."
    exit 1
fi

if grep -q "swmando-3" "$ANSIBLE_HOSTS"; then
    # Update existing entry
    sed -i "s/\(swmando-3.*ansible_port=\)[0-9]*/\1$port_3/" "$ANSIBLE_HOSTS"
    echo "Updated swmando-3 in hosts file with ansible_port=$port_3."
else
    echo "swmando-3 entry not found in hosts file."
    exit 1
fi

# Ping to test
ansible -i hosts all -m ping
