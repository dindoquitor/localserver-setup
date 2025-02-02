FROM php:fpm-alpine

RUN apk add --no-cache $PHPIZE_DEPS
RUN pecl install xdebug 

RUN docker-php-ext-enable xdebug 
RUN docker-php-ext-install pdo pdo_mysql

# Configure maildev

RUN apk update
RUN apk add ssmtp

RUN echo "hostname=web.local" > /etc/ssmtp/ssmtp.conf
RUN echo "root=mailer@web.local>" >> /etc/ssmtp/ssmtp.conf
RUN echo "mailhub=maildev:1025" >> /etc/ssmtp/ssmtp.conf

RUN echo "sendmail_path=sendmail -i -t" >> /usr/local/etc/php/conf.d/php-sendmail.ini
RUN sed -i '/#!\/bin\/sh/aecho "$(hostname -i)\t$(hostname) $(hostname).localhost" >> /etc/hosts' /usr/local/bin/docker-php-entrypoint

RUN echo "post_max_size=5000M" > /usr/local/etc/php/conf.d/php-uploadsize.ini
RUN echo "upload_max_filesize=5000M" >> /usr/local/etc/php/conf.d/php-uploadsize.ini