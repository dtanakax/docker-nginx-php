######################################################################
# Dockerfile to build Nginx+PHP
# Author: tanaka@infocorpus.com
######################################################################

# Set the base image
FROM tanaka0323/centosjp:latest

# File Author / Maintainer
MAINTAINER tanaka@infocorpus.com

# Add the ngix and PHP dependent repository
ADD nginx.repo /etc/yum.repos.d/nginx.repo

# Yum update
RUN yum -y update
RUN yum -y upgrade

# Remi Dependency on CentOS 7 and Red Hat (RHEL) 7 ##
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
RUN rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm --rebuilddb

# Installing tools
RUN yum install -y --enablerepo=remi,remi-php56 wget nginx php-fpm php-mbstring php-mysql php-gd python-setuptools
RUN easy_install pip
RUN pip install supervisor

# Clean up
RUN yum clean all

# Adding the configuration file of the nginx
ADD nginx.conf /etc/nginx/nginx.conf
ADD default.conf /etc/nginx/conf.d/default.conf
ADD cert.crt /etc/nginx/certs/cert.crt
ADD cert.key /etc/nginx/certs/cert.key

# Adding the default file
ADD index.php /var/www/html/index.php
RUN chown -R nginx:nginx /var/www/

# Adding the configuration file of the Supervisor
ADD supervisord.conf /etc/

# Configure php-fpm.conf
RUN sed -i -e "s/;events.mechanism = epoll/events.mechanism = epoll/g" /etc/php-fpm.conf

# Configure www.conf
RUN sed -i -e "s/user = apache/user = nginx/g" /etc/php-fpm.d/www.conf
RUN sed -i -e "s/group = apache/group = nginx/g" /etc/php-fpm.d/www.conf
RUN sed -i -e "s/;listen.owner = nobody/listen.owner = nginx/g" /etc/php-fpm.d/www.conf
RUN sed -i -e "s/;listen.group = nobody/listen.group = nginx/g" /etc/php-fpm.d/www.conf
RUN sed -i -e "s/;listen.mode = 0660/listen.mode = 0660/g" /etc/php-fpm.d/www.conf
RUN sed -i -e "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm\/php-fpm.sock/g" /etc/php-fpm.d/www.conf

# Configure php.ini
RUN sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /etc/php.ini
RUN sed -i "s/post_max_size = 8M/post_max_size = 10M/g" /etc/php.ini
RUN sed -i 's/;date.timezone =/date.timezone = "Asia\/Tokyo"/g' /etc/php.ini

# Define mountable directories.
VOLUME ["/etc/nginx", "/var/log/nginx", "/var/log/php-fpm", "/var/www/html"]

# Set the port to 80 443
EXPOSE 80 443

# Executing sh
CMD ["supervisord", "-n"]