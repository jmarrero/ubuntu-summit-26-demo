FROM docker.io/library/ubuntu:26.04

RUN apt-get update && apt-get install -y apache2 && rm -rf /var/lib/apt/lists/*

COPY index.html /var/www/html/index.html

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
