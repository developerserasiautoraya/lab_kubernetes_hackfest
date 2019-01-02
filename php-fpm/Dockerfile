FROM bitnami/php-fpm:7.1

ENV ACCEPT_EULA=Y

# Microsoft SQL Server Prerequisites
RUN apt-get update
RUN apt-get -y --no-install-recommends install curl autoconf make gcc g++ unixodbc unixodbc-dev sed \
    && pecl install sqlsrv pdo_sqlsrv mongodb redis

# Install composer
RUN curl -sS https://getcomposer.org/installer | php

RUN printf "\nextension=sqlsrv.so" >> /opt/bitnami/php/etc/php.ini && \
    printf "\nextension=pdo_sqlsrv.so" >> /opt/bitnami/php/etc/php.ini && \
    printf "\nextension=mongodb.so" >> /opt/bitnami/php/etc/php.ini && \
    printf "\nextension=redis.so" >> /opt/bitnami/php/etc/php.ini && \
    sed -i s/^upload_max_filesize.*/upload_max_filesize\ =\ 32M/g /opt/bitnami/php/etc/php.ini && \
    sed -i s/^post_max_size.*/post_max_size\ =\ 32M/g /opt/bitnami/php/etc/php.ini && \
    sed -i s/^memory_limit.*/memory_limit\ =\ 1024M/g /opt/bitnami/php/etc/php.ini && \
    sed -i s/^pm.max_children.*/pm.max_children\ =\ 200/g /opt/bitnami/php/etc/php-fpm.d/www.conf && \
    printf "\nphp_admin_value[upload_max_filesize] = 32M" >> /opt/bitnami/php/etc/php-fpm.d/www.conf && \
    printf "\nphp_admin_value[post_max_size] = 32M" >> /opt/bitnami/php/etc/php-fpm.d/www.conf && \
    printf "\nphp_flag[display_errors] = off" >> /opt/bitnami/php/etc/php-fpm.d/www.conf && \
    printf "\nphp_flag[expose_php] = Off" >> /opt/bitnami/php/etc/php-fpm.d/www.conf && \
    printf "\npm.process_idle_timeout = 10s" >> /opt/bitnami/php/etc/php-fpm.d/www.conf
    
# Remove Cache
RUN apt-get remove --purge -y --allow-remove-essential autoconf make gcc g++ sed && \
    apt-get clean -y && \
    apt-get autoremove --purge -y && \
    apt-get autoclean --dry-run -y && \
    rm -rf /tmp/*

COPY app /app
