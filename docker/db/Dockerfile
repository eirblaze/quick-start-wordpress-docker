FROM mysql:8 as builder

# tzdataをインストールする際に対話シェルが開始されます。
# Dockerイメージをビルドする際に対話シェルが開始されると処理が止まってしまうので、 DEBIAN_FRONTEND を指定して対話シェルが開始されないようにしています。
# [あしたからがんばる](https://toyo.hatenablog.jp/entry/2019/11/13/131024)
ENV DEBIAN_FRONTEND noninteractive

#
# MySQLが載ってるOSのタイムゾーンを日本時間にする [DockerのMySQL imageでタイムゾーンを日本時間にする](https://qiita.com/rowpure/items/dbedbe2b98e91a34d0d5)
RUN apt-get update
RUN apt-get install -y tzdata
    # cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

#
# MySQLのタイムゾーンを日本時間にする [DockerのMySQL imageでタイムゾーンを日本時間にする](https://qiita.com/rowpure/items/dbedbe2b98e91a34d0d5)
# RUN /usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo

#
# [mysqlのタイムゾーンがUTCでapplication.rbのconfig.time_zone=localの場合、date/datetimeをgroupするとタイムゾーンがUTC使われる件](http://mikodayo.hatenablog.com/entry/2015/06/30/130637)
# RUN /usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -p${MYSQL_ROOT_PASSWORD} mysql
# RUN /usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root -pwordpress mysql

# RUN /usr/bin/mysql_tzinfo_to_sql /usr/share/zoneinfo > ~/timezone.sql
# RUN mysql -u root -p${MYSQL_ROOT_PASSWORD} -D mysql < ~/timezone.sql
# RUN mysql -u root -pwordpress -D mysql < ~/timezone.sql

#
# [mysql dockerコンテナにタイムゾーンを設定する ](https://www.366service.com/jp/qa/3a0e1ec8247734eeeab5f2dd6a183092)
RUN echo "USE mysql;" > /docker-entrypoint-initdb.d/timezones.sql \
    && mysql_tzinfo_to_sql /usr/share/zoneinfo >> /docker-entrypoint-initdb.d/timezones.sql
# RUN mysql -u root -pwordpress -D mysql < /docker-entrypoint-initdb.d/timezones.sql

#
# 永続するコンテナ
FROM mysql:8

COPY --from=builder /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
COPY --from=builder /docker-entrypoint-initdb.d/timezones.sql /docker-entrypoint-initdb.d/
COPY ./conf/.my.cnf /root/

WORKDIR /root

# SELECT ID,post_date_gmt,CONVERT_TZ(post_date_gmt,'GMT','JST') AS JST,post_title FROM wordpress.wp_posts;
# SELECT now();
# USE wordpress; CREATE VIEW jst_test AS SELECT ID,post_date_gmt,CONVERT_TZ(post_date_gmt,'GMT','JST') JST,post_title FROM wp_posts;

#
# MySQLを実行します。実質のentrypointです。
# [あしたからがんばる](https://toyo.hatenablog.jp/entry/2019/11/13/131024)
# [Docker で MySQL 起動時にデータの初期化を行う](https://qiita.com/moaikids/items/f7c0db2c98425094ef10)
CMD ["mysqld"]
