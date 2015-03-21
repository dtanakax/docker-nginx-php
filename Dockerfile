# Set the base image
FROM tanaka0323/debianjp:latest

# File Author / Maintainer
MAINTAINER Daisuke Tanaka, tanaka@infocorpus.com

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates wget

RUN wget http://nginx.org/keys/nginx_signing.key -O- | apt-key add - && \
    echo "deb http://nginx.org/packages/mainline/debian/ wheezy nginx" >> /etc/apt/sources.list && \
    wget http://www.dotdeb.org/dotdeb.gpg -O- | apt-key add - && \
    echo "deb http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list.d/dotdeb.list

RUN apt-get update && \
    apt-get install -y procps nginx php5-fpm php5-mcrypt php5-mysql php5-gd supervisor && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get clean

# Adding the configuration file of the nginx
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY default.crt /etc/nginx/certs/default.crt
COPY default.key /etc/nginx/certs/default.key

# Adding the default file
ADD index.php /var/www/html/index.php
RUN chown -R nginx:nginx /var/www/

# Adding the configuration file of the Supervisor
ADD supervisord.conf /etc/

# Configure php-fpm.conf
RUN sed -i -e "s/;events.mechanism = epoll/events.mechanism = epoll/g" /etc/php5/fpm/php-fpm.conf

# Configure www.conf
RUN sed -i -e "s/user = www-data/user = nginx/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/group = www-data/group = nginx/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/listen.owner = nobody/listen.owner = nginx/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/listen.group = nobody/listen.group = nginx/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/;listen.mode = 0660/listen.mode = 0660/g" /etc/php5/fpm/pool.d/www.conf

# Configure php.ini
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /etc/php5/fpm/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = 10M/g" /etc/php5/fpm/php.ini
RUN sed -i 's/;date.timezone =/date.timezone = "Asia\/Tokyo"/g' /etc/php5/fpm/php.ini

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Define mountable directories.
VOLUME ["/etc/nginx", "/etc/nginx/certs", "/var/cache/nginx"]

# Set the port to 80 443
EXPOSE 80 443

# Executing sh
CMD ["supervisord", "-n"]