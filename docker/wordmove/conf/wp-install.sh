#!/bin/bash

set -ex;

wp core download --version=latest

wp config create \
    --dbname=${MYSQL_DATABASE} \
    --dbuser=${MYSQL_USER} \
    --dbpass=${MYSQL_PASSWORD} \
    --dbhost=${LOCAL_DB_HOST}:${LOCAL_DB_PORT} \
    --dbprefix=${WP_DB_PREFIX}

wp core install \
    --url=https://localhost \
    --title=${WP_TITLE} \
    --admin_user=${WP_USER} \
    --admin_password=${WP_PASS} \
    --admin_email=${WP_MAIL}

wp core language install ja --activate

wp plugin install \
    wp-multibyte-patch logbook \
    show-current-template query-monitor \
    ithemes-security \
    contact-form-7 flamingo
#   classic-editor advanced-custom-fields custom-post-type-ui custom-post-type-permalinks \
#   tinymce-advanced \
#   --activate

# [WP-CLI で WordPress を日本語パッケージと同じ構成にする](https://qiita.com/miya0001/items/96a684e2f819f9d8b4a4)
wp option update timezone_string $(wp eval "echo _x( '0', 'default GMT offset or timezone string' );")
wp option update date_format "Y-m-d"
