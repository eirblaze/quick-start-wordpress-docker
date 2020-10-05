#!/bin/sh

set -e

#
# Dockerのストレージエンジン(overlay2)とMySQLの相性が悪いらしく、そのままではCan’t open and lock privilege tables: Table storage engine for ‘user’ doesn’t have this optionというエラーが発生します。
# https://github.com/docker/for-linux/issues/72
find /var/lib/mysql -type f -exec touch {} \;

if [ ! -f timezone_applied ];then
  mysqld &
  sleep 3
  mysql -uroot -D mysql < timezone.sql
  mysqladmin shutdown -uroot
  touch timezone_applied
fi

#
# MySQLを実行します。実質のentrypointです。
mysqld