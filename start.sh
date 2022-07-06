#!/bin/bash
if [ ! -f my_secret.txt ]; then
	cp my_secret.template my_secret.txt
fi
docker-compose up -d

