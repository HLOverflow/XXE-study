FROM nimmis/apache-php7
RUN apt-get update && apt-get install -y php-dom
WORKDIR /var/www/html
COPY ./src/ .
COPY ./flag.php /etc/.flag.php
