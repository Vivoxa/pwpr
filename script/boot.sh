#!/bin/bash
set -e

    if [[ $@ == *"--clean"* ]] ;then
      echo 'Cleaning...'
      docker-compose kill
      docker-compose down -v
    fi

    docker-compose up -d
		docker attach pwpr_app
