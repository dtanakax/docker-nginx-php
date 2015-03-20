#!/bin/bash
set -e

mv -f /etc/nginx/certs/cert.crt /etc/nginx/certs/$VIRTUAL_HOST.crt;
mv -f /etc/nginx/certs/cert.key /etc/nginx/certs/$VIRTUAL_HOST.key;

sed -i -e "s/VIRTUAL_HOST/$VIRTUAL_HOST/g" /etc/nginx/conf.d/default.conf

# Executing supervisord
supervisord -n