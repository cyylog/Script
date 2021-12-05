#!/bin/bash
docker rm -f rabbitmq
docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 \
        -v /export/rabbitmq/data:/var/lib/rabbitmq --hostname myRabbit \
        -e RABBITMQ_DEFAULT_VHOST=/  \
        -e RABBITMQ_DEFAULT_USER=admin \
        -e RABBITMQ_DEFAULT_PASS=admin \
        10.7.92.101:5000/rabbitmq:3.8.11-management-alpine
