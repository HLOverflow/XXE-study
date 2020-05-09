FROM nimmis/apache-php7
RUN apt-get update && apt-get install -y php-dom
WORKDIR /var/www/html
COPY ./src/ .
COPY ./flag.php /etc/.flag.php

# To demonstrate SSRF AWS, comment the following out if not required.
RUN apt-get update && apt-get install -y iptables
RUN apt-get install -y iputils-ping
COPY ./setup-aws-simulator.sh /
RUN chmod +x /setup-aws-simulator.sh
ENTRYPOINT /setup-aws-simulator.sh && /my_init
#ENTRYPOINT /my_init
