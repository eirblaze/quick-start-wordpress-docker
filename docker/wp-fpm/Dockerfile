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
FROM wordpress:5.3.2-php7.4-fpm-alpine

# ビルドしたモジュールを取得
COPY --from=builder /usr/local/lib/php/extensions/no-debug-non-zts-20190902/xdebug.so /usr/local/lib/php/extensions/no-debug-non-zts-20190902/

ENV WP_HTM_DIR /var/www/html

RUN apk add --no-cache \
#
# mailcatcher にメールを送る仕掛け
  msmtp \
  ; \
#
# ソケットを置く場所
  mkdir -p /var/run/php-fpm ; \
  chown www-data:www-data /var/run/php-fpm ; \
#
# XDebug
  docker-php-ext-enable xdebug

#ENV PHP_INI_DIR /etc/php7
COPY ./conf/my-php.ini ${PHP_INI_DIR}/conf.d/
COPY ./conf/msmtprc /etc/msmtprc

# [PHPの公式DockerイメージでUNIXソケット通信しようとして罠にハマるの巻](https://yoshinorin.net/2017/03/06/php-official-docker-image-trap/)
# fpm の設定ファイルを zzz-www.conf としていますが、これは 公式イメージが zz-docker.conf で listen 設定をぶっ潰しているのに対抗 [docker-compose を使って（なるべく）公式イメージで PHP 開発環境を作った](https://qiita.com/hidekuro/items/46c00dec350c4a37fbb1#php)
# https://github.com/docker-library/php/blob/cdebaa8f318d4d20a492da372d24cb496041fe56/5.5/fpm/Dockerfile#L103
COPY ./conf/zzz-my-fpm.conf /usr/local/etc/php-fpm.d/zzz-my-fpm.conf

# ユーザー権限付与
# [dockerでvolumeをマウントしたときのファイルのowner問題](https://qiita.com/yohm/items/047b2e68d008ebb0f001)
# COPY ./conf/entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# CMD ["tail", "-f", "/dev/null"]
# RUN apk add --no-cache --virtual .builddeps shadow ; \
#     usermod -u 0 -o www-data ; \
#     groupmod -g 0 -o www-data ; \
#     apk del .builddeps

WORKDIR ${WP_HTM_DIR}
