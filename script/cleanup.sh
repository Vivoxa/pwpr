#!/bin/sh
echo cleanup started
echo stop all containers
docker stop $(docker ps -q)
echo removed untagged images
docker rmi -f $(docker images -q -a -f dangling=true)
docker rm -v $(docker ps -a -q -f status=exited)
echo cleanup complete