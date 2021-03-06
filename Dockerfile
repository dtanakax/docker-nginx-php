# Set the base image
FROM dtanakax/nginx:1.9.3

# File Author / Maintainer
MAINTAINER Daisuke Tanaka, dtanakax@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN wget http://www.dotdeb.org/dotdeb.gpg -O- | apt-key add - && \
    echo "deb http://packages.dotdeb.org wheezy-php56 all" >> /etc/apt/sources.list.d/dotdeb.list

RUN apt-get update && \
    apt-get install -y supervisor php5-fpm php5-mcrypt php5-mysql php5-gd && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get clean all

# Adding the configuration file of the nginx
COPY default.conf /etc/nginx/conf.d/default.conf
RUN touch /var/log/php5-fpm.log
RUN chown -R nginx:nginx /var/log/php5-fpm.log

# Adding the default file
ADD index.php /var/www/html/index.php

# Adding the configuration file
ADD supervisord.conf /etc/
ADD start.sh /start.sh
RUN chmod +x /start.sh

# Configure php-fpm.conf
RUN sed -i -e "s/;events.mechanism = epoll/events.mechanism = epoll/g" /etc/php5/fpm/php-fpm.conf

# Configure www.conf
RUN sed -i -e "s/user = www-data/user = nginx/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/group = www-data/group = nginx/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/listen.owner = nobody/listen.owner = nginx/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/listen.group = nobody/listen.group = nginx/g" /etc/php5/fpm/pool.d/www.conf
RUN sed -i -e "s/;listen.mode = 0660/listen.mode = 0666/g" /etc/php5/fpm/pool.d/www.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/php5-fpm.log

ENV UPLOAD_MAX_SIZE 50M
ENV DATE_TIMEZONE Asia/Tokyo

ENTRYPOINT ["./start.sh"]

# Set the port to 80
EXPOSE 80 443

# Executing sh
CMD ["supervisord", "-n"]