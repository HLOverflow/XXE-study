FROM nimmis/apache-php7
RUN apt-get update
RUN apt-get install -y php-dom 
WORKDIR /var/www/html
COPY ./src/ .
COPY ./flag.php /etc/.flag.php

# add "expect" module for RCE demonstration
RUN apt-get install -y tcl-expect-dev php-pear php-pecl-http php7.0-dev
RUN pear channel-update pear.php.net
RUN pecl channel-update pecl.php.net
RUN pecl install expect
RUN sed -i 's/;extension=php_xsl.dll/;extension=php_xsl.dll\nextension=expect.so/' /etc/php/7.0/apache2/php.ini

# To demonstrate SSRF AWS, comment the following out if not required.
RUN apt-get update && apt-get install -y iptables
RUN apt-get install -y iputils-ping
COPY ./setup-aws-simulator.sh /
RUN chmod +x /setup-aws-simulator.sh

# set www-data as the owner
RUN chown -R "www-data:www-data" /var/www/html

# Set up entrypoint
ENTRYPOINT /setup-aws-simulator.sh && /my_init
#ENTRYPOINT /my_init
