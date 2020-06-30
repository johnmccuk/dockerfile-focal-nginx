# Dockerfile for Ubuntu 18.04 nginx

# Pull base image.
FROM ubuntu:20.04

# Maintainer
MAINTAINER John McCracken <john.mccracken@qanw.co.uk>

# Install Packages
RUN DEBIAN_FRONTEND=noninteractive apt update -y && apt-get install software-properties-common -y && add-apt-repository ppa:ondrej/php -y && apt update -y && DEBIAN_FRONTEND=noninteractive apt install -y vim nginx nodejs npm \
    supervisor php7.4-fpm php7.4-mbstring php7.4-zip php-xdebug php-memcached php-imagick libssh2-1 libssl1.1 php-curl php-ssh2 php7.4-mysql php7.4-xml composer rsyslog zip unzip && apt clean && service php7.4-fpm start && usermod -u 1000 www-data

COPY ./conf/nginx.conf /etc/nginx/sites-enabled/default
COPY ./conf/php-custom.ini /etc/php/7.4/fpm/conf.d/99-custom.ini
COPY ./conf/php-fpm-pool.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY ./webroot /var/www/html

EXPOSE 443 80

#Supervisor
COPY ./conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
CMD ["/usr/bin/supervisord"]

