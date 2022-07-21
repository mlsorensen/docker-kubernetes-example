#!/usr/bin/env bash

docker build -t nodeserver:latest .
if [[ $? != 0 ]]
then
    echo "Error detected on docker build! - $?"
    exit 1
fi

# This command takes 32 seconds.  Why does it take 32 seconds to simply shut down a running pod, and re-install it?
kubectl replace --force -f ./pod.yaml
if [[ $? != 0 ]]
then
    echo "Error detected on kubectl replace! - $?"
    exit 1
fi

exit 0
