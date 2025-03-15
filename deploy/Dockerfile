ARG COMPOSER_IMAGE="base"
FROM wyveo/nginx-php-fpm:php82 as base

RUN sed -i 's|deb http://nginx.org/packages/mainline/debian/ bullseye nginx|#deb http://nginx.org/packages/mainline/debian/ bullseye nginx|' /etc/apt/sources.list \
    && sed -i 's|deb https://packages.sury.org/php/ bullseye main|#deb https://packages.sury.org/php/ bullseye main|' /etc/apt/sources.list.d/php.list || true

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    curl \
    gnupg2 \
    ca-certificates \
    apt-transport-https

RUN curl -fsSL https://nginx.org/keys/nginx_signing.key | gpg --dearmor -o /usr/share/keyrings/nginx-archive-keyring.gpg \
    && curl -fsSL https://packages.sury.org/php/apt.gpg | gpg --dearmor -o /usr/share/keyrings/sury-php.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/debian bullseye nginx" > /etc/apt/sources.list.d/nginx.list \
    && echo "deb [signed-by=/usr/share/keyrings/sury-php.gpg] https://packages.sury.org/php/ bullseye main" > /etc/apt/sources.list.d/sury-php.list

RUN apt-get update -y && apt-get install -y \
    cron \
    libxml2-dev \
    php-soap \
    php8.2-soap \
    php8.2-gmp


RUN touch /var/log/cron.log
RUN  chown -R nginx  /var/log/cron.log
USER nginx

RUN (crontab -l 2>/dev/null; echo "* * * * * /usr/bin/php /usr/share/nginx/artisan schedule:run >> /var/log/cron.log 2>&1") | crontab -

USER root
WORKDIR /usr/share/nginx

EXPOSE 80
ENTRYPOINT ["/start.sh"]

FROM ${COMPOSER_IMAGE} as composer

COPY ./deploy/default.conf /etc/nginx/conf.d/default.conf
COPY ./deploy/start.sh /start.sh
RUN chmod +x /start.sh

COPY ./composer.json .
COPY ./composer.lock .
RUN composer i --no-scripts

FROM ${COMPOSER_IMAGE} as app
COPY . .
