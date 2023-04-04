FROM php:7.1-apache-stretch

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

RUN rm /etc/apt/preferences.d/no-debian-php

RUN apt-get update &&\
    apt-get install -y --no-install-recommends wget unzip php-mysql &&\
    apt-get clean

RUN docker-php-ext-install mysqli

RUN chmod 777 /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
