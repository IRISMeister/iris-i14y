#!/bin/bash
if [ ! -f yahoo_cred.json ]; then
	cp yahoo_cred.template yahoo_cred.json
fi
if [ ! -f gmail_cred.json ]; then
	cp gmail_cred.template gmail_cred.json
fi
docker-compose up -d

