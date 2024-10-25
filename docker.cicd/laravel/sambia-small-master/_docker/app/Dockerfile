FROM php:7.2-fpm

RUN apt update && apt-get install -y \
      apt-utils \
      libpq-dev \
      libpng-dev \
      libzip-dev \
      zip unzip \
      git && \
      docker-php-ext-install pdo_mysql && \
      docker-php-ext-install bcmath && \
      docker-php-ext-install gd && \
      docker-php-ext-install zip && \
      apt-get clean && \
      # php7.2 php7.2-mbstring php7.2-xml php7.2-bcmath php7.2-zip curl unzip php7.2-gd php7.2-curl php7.2-json php7.2-mysql php7.2-sqlite3 && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#копируем php.ini
COPY ./_docker/app/php.ini /usr/local/etc/php/conf.d/php.ini


#Install composer
# ENV COMPOSER_ALLOW_SUPERUSER=1
# RUN curl -sS https://getcomposer.org/installer | php -- \
#     --filename=composer \
#     --install-dir=/usr/local/bin

WORKDIR /var/www


