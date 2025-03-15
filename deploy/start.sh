#!/bin/bash
composer run post-autoload-dump
php artisan config:clear
php artisan cache:clear

mkdir -p /usr/share/nginx/storage/app/private
mkdir -p /usr/share/nginx/storage/app/public
mkdir -p /usr/share/nginx/storage/framework/cache/data
mkdir -p /usr/share/nginx/storage/framework/sessions
mkdir -p /usr/share/nginx/storage/framework/testing
mkdir -p /usr/share/nginx/storage/framework/views
mkdir -p /usr/share/nginx/storage/logs

cron

procs=$(cat /proc/cpuinfo | grep processor | wc -l)
sed -i -e "s/worker_processes  1/worker_processes $procs/" /etc/nginx/nginx.conf

chown -Rf nginx:nginx /usr/share/nginx
chown -R nginx:nginx /usr/share/nginx/storage /usr/share/nginx/bootstrap/cache
chmod -R 775 /usr/share/nginx/storage /usr/share/nginx/bootstrap/cache

/usr/local/bin/supervisord -n -c /etc/supervisord.conf
