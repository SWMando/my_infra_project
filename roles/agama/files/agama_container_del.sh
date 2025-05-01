#!/bin/bash

docker ps -a --filter "name=agama" --format "{{.ID}} {{.Status}}" | while read container_id status; do
    if [[ "$status" == "Exited"* ]]; then
        # If the container is in the Exited state, remove it directly
        docker rm "$container_id"
    else
        # If the container is running, stop it first and then remove it
        docker kill "$container_id" && docker rm "$container_id"
    fi
done

