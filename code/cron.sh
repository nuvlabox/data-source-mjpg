#!/bin/sh

# Auxiliary script to make sure this streamer is proxied through the NB Data Gateway

while true
do
  sleep 45
  curl -f http://data-gateway/video/$(hostname) 2>&1 || echo "Service proxying is down in NuvlaBox Data Gateway, restarting container..." && kill `pgrep tini`
done