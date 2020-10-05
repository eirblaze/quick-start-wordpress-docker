FROM php:7.4-fpm-alpine as builder

#
# ビルド用コンテナ
RUN apk add --no-cache --virtual .builddeps \
    #
    # docker-php-ext- 系を動かすのに必要 [php-alpineコンテナにxdebugをインストールする時にハマったメモ](https://qiita.com/ucan-lab/items/fbf021bf69896538e515)
    autoconf \
    #
    # XDebug ビルドに使う[php-alpineコンテナにxdebugをインストールする時にハマったメモ](https://qiita.com/ucan-lab/items/fbf021bf69896538e515)
    gcc g++ make \
  ; \
  #
  # XDebug
  pecl install xdebug ; \
  #
  # imagick for WordPress
  # pecl install imagick ; \
  #
  # 軽量化 [Alpine Linux で軽量な Docker イメージを作る](https://qiita.com/pottava/items/970d7b5cda565b995fe7)
  apk del .builddeps

#
# 永続するコンテナ
FROM php:7.4-fpm-alpine

ENV WP_HTM_DIR /var/www/html

# ビルドしたモジュールを取得
COPY --from=builder /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/

#
# 永続するアプリ追加
RUN apk add --no-cache \
    #
    # mailcatcher にメールを送る仕掛け
    msmtp \
    #
    # for WordPress REST API
    curl \
    #
    # for WordPress
    freetype-dev \
    zlib-dev \
    libzip-dev \
    libjpeg \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    libpng \
    libpng-dev \
    libxml2-dev \
    libxpm-dev \
    libxslt-dev \
    libwebp-dev \
    jpeg-dev \
  ; \
  #
  # ソケットを置く場所
  mkdir -p /var/run/php-fpm ; \
  chown www-data:www-data /var/run/php-fpm ; \
  #
  # add module
  docker-php-ext-enable xdebug ; \
  # docker-php-ext-enable imagick ; \
  #
  # for WordPress
  docker-php-ext-install zip; \
  docker-php-ext-install mysqli; \
  docker-php-ext-install -j$(nproc) gd ; \
  docker-php-ext-install exif; \
  docker-php-ext-configure zip; \
  docker-php-ext-configure mysqli ; \
  docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ ; \
  docker-php-ext-configure exif


#ENV PHP_INI_DIR /etc/php7
COPY ./conf/my-php.ini ${PHP_INI_DIR}/conf.d/
COPY ./conf/msmtprc /etc/msmtprc

# [PHPの公式DockerイメージでUNIXソケット通信しようとして罠にハマるの巻](https://yoshinorin.net/2017/03/06/php-official-docker-image-trap/)
# fpm の設定ファイルを zzz-www.conf としていますが、これは 公式イメージが zz-docker.conf で listen 設定をぶっ潰しているのに対抗 [docker-compose を使って（なるべく）公式イメージで PHP 開発環境を作った](https://qiita.com/hidekuro/items/46c00dec350c4a37fbb1#php)
# https://github.com/docker-library/php/blob/cdebaa8f318d4d20a492da372d24cb496041fe56/5.5/fpm/Dockerfile#L103
COPY ./conf/zzz-my-fpm.conf /usr/local/etc/php-fpm.d/zzz-my-fpm.conf

WORKDIR ${WP_HTM_DIR}
