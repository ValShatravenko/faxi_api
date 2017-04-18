FROM centos:6
MAINTAINER Valentine Shatravenko <vshatravenko@heliostech.fr>

ENV httpd_conf /code/httpd.conf

RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
RUN rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# Ioncube installation
RUN yum install --enablerepo=epel,remi-php56,remi -y \
                              php \
                              php-cli \
                              php-gd \
                              php-mbstring \
                              php-mcrypt \
                              php-mysqlnd \
                              php-pdo \
                              php-xml \
                              php-xdebug \
                              php56-php-ioncube-loader.x86_64

# Ioncube Loader installation
RUN yum install -y wget
RUN wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
RUN tar xzvf ioncube_loaders_lin_x86-64.tar.gz
RUN mkdir /usr/local/ioncube
RUN cp -p ioncube/ioncube_loader_lin_5.6.so /usr/local/ioncube/
RUN rm -rf ioncube*
RUN echo "zend_extension = /usr/local/ioncube/ioncube_loader_lin_5.6.so" >> /etc/php.ini

# Apache installation
RUN yum install -y httpd

RUN sed -i -e "s|^;date.timezone =.*$|date.timezone = Europe/Kiev|" /etc/php.ini
ADD httpd.conf $httpd_conf
RUN test -e $httpd_conf && echo "Include $httpd_conf" >> /etc/httpd/conf/httpd.conf


EXPOSE 80
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
