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

WORKDIR /var/www

# копируем все файлы проекта в рабочую директорию исключая указанные в .dockerignore 
COPY --chown=root:www-data --chmod=775 . .

# Настраиваем права доступа для веб-сервера
#RUN chown -R www-data:www-data /var/www/storage
# RUN composer dump-autoload  --no-scripts --optimize && \
# RUN chown -R root:www-data /var/www && \
#     chmod -R 775 /var/www && \
#     chmod -R 775 /var/www/storage 


#COPY composer.*  ./

#Install composer
 ENV COMPOSER_ALLOW_SUPERUSER=1
 RUN curl -sS https://getcomposer.org/installer | php -- \
    --filename=composer \
    --install-dir=/usr/local/bin
# alias
RUN echo "alias a='artisan'" >> /root/.bashrc


#RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
#RUN apt-get install -y nodejs
    
# Настраиваем рабочий процесс для Nginx
#CMD ["php-fpm"]
