FROM php:7.1-apache-stretch

WORKDIR /app

RUN rm /etc/apt/preferences.d/no-debian-php

RUN apt-get update &&\
    apt-get install -y --no-install-recommends wget unzip php-mysql &&\
    apt-get clean

RUN docker-php-ext-install mysqli

RUN wget -nv -O /app/ce-phoenix-cart.zip https://github.com/CE-PhoenixCart/PhoenixCart/archive/master.zip

RUN unzip ce-phoenix-cart.zip -d ce-phoenix-cart-temp
RUN mv ce-phoenix-cart-temp/PhoenixCart-master/* /var/www/html/

RUN chmod 777 /var/www/html/includes/configure.php
RUN chmod 777 /var/www/html/admin/includes/configure.php


EXPOSE 80
CMD ["apache2-foreground"]
