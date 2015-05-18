#!/bin/bash

FIRSTRUN=/firstrun
if [ ! -f $FIRSTRUN ]; then
    if [ -d "/var/www/html" ]; then
        chown -R nginx:nginx /var/www/html
    fi

    # Configure php.ini
    sed -i "s|^upload_max_filesize =.*$|upload_max_filesize = ${UPLOAD_MAX_SIZE}|
            s|^post_max_size =.*$|post_max_size = ${UPLOAD_MAX_SIZE}|
            s|^;date.timezone =|date.timezone = \"${DATE_TIMEZONE}\"|g" /etc/php5/fpm/php.ini

    touch $FIRSTRUN
fi

exec "$@"