#!/bin/sh

# Auxiliary script to make sure this streamer is proxied through the NB Data Gateway

while true
do
  sleep 30
  curl -f -s http://data-gateway/video/$(hostname) >/dev/null || (echo "Service proxying is down in NuvlaBox Data Gateway, restarting container..." && kill `pgrep tini`)
done