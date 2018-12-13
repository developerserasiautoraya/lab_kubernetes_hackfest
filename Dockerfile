FROM centos:centos7

RUN rpm --import https://archive.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 && \
rpm --import https://mirror.webtatic.com/yum/RPM-GPG-KEY-webtatic-el7

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
RUN yum -y update
RUN yum -y install nano nginx php70w-cli php70w-common php70w-gd php70w-mbstring php70w-mcrypt php70w-mysql php70w-xml php70w-pdo php70w-soap php70w-fpm php70w-pear php70w-devel gcc gcc-c++ unixODBC unixODBC-devel.x86_64 git nodejs
RUN pecl install sqlsrv pdo_sqlsrv mongodb

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN touch /etc/php.d/sqlsrv.ini && \
printf "\nextension=sqlsrv.so" >> /etc/php.d/sqlsrv.ini && \
printf "\nextension=pdo_sqlsrv.so" >> /etc/php.d/sqlsrv.ini && \
printf "\nextension=mongodb.so" >> /etc/php.d/sqlsrv.ini && \
sed -i s/^upload_max_filesize.*/upload_max_filesize\ =\ 32M/g /etc/php.ini && \
sed -i s/^post_max_size.*/post_max_size\ =\ 32M/g /etc/php.ini && \
echo "php_admin_value[upload_max_filesize] = 32M" >> /etc/php-fpm.d/www.conf && \
echo "php_admin_value[post_max_size] = 32M" >> /etc/php-fpm.d/www.conf && \
echo "php_flag[display_errors] = off" >> /etc/php-fpm.d/www.conf && \
echo "php_flag[expose_php] = Off" >> /etc/php-fpm.d/www.conf && \
sed -i 's;^user\ =\ .*;user\ =\ nginx;' /etc/php-fpm.d/www.conf && \
sed -i 's;^group\ =\ .*;group\ =\ nginx;' /etc/php-fpm.d/www.conf && \
sed -i 's;^listen\ =\ .*;listen\ =\ \/run\/php-fpm\/php-fpm.sock;' /etc/php-fpm.d/www.conf && \
sed -i 's;^\;listen.owner\ =\ .*;listen.owner\ =\ nginx;' /etc/php-fpm.d/www.conf && \
sed -i 's;^\;listen.group\ =\ .*;listen.group\ =\ nginx;' /etc/php-fpm.d/www.conf

RUN yum remove -y gcc gcc-c++

RUN yum clean all
RUN rm -rf /var/cache/yum /tmp/* /var/tmp/*

COPY config/nginx.conf /etc/nginx/nginx.conf
RUN chmod 644 /etc/nginx/nginx.conf

COPY config/default.conf /etc/nginx/conf.d/default.conf
RUN chmod 644 /etc/nginx/conf.d/default.conf

RUN rm -rf /usr/share/nginx/html/*
COPY html /usr/share/nginx/html
#RUN chown -R 1001:1001 /usr/share/nginx/html/*

CMD usermod -a -G root 1001
CMD /usr/sbin/php-fpm && /usr/sbin/nginx -g 'daemon off;' && /usr/sbin/nginx -c /etc/nginx/nginx.conf

EXPOSE 80
EXPOSE 443
