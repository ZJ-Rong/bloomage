FROM chicked/php74-apache-with-code
MAINTAINER chicked <qq307365873@gmail.com>

RUN docker-php-ext-install pcntl
RUN docker-php-ext-enable opcache

#部署代码
RUN mkdir -p /app
WORKDIR /app
COPY ./composer.json /app/
COPY ./composer.lock /app/
RUN composer install --prefer-dist  --no-autoloader --no-scripts
COPY . /app
RUN composer install --prefer-dist
##RUN chown -R www-data:www-data /app \
##    && chmod 777 -R /app/public/images/merge-images

#配置虚拟主机
RUN rm -rf /var/www/html && ln -s /app/public /var/www/html
RUN echo "post_max_size = 16m" >> /usr/local/etc/php/php.ini

EXPOSE 80

CMD ["/usr/bin/supervisord"]
