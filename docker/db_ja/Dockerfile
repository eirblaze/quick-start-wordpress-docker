FROM ubuntu:18.04

#
# [あしたからがんばる](https://toyo.hatenablog.jp/entry/2019/11/13/131024)

ENV TZ Asia/Tokyo
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        mysql-server \
        tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# timezone
WORKDIR /opt
RUN mysql_tzinfo_to_sql /usr/share/zoneinfo > timezone.sql

# mysql
RUN mkdir -p /var/run/mysqld \
    && chown mysql:mysql /var/run/mysqld \
    && usermod -d /var/lib/mysql mysql \
    && mv /etc/mysql/conf.d/mysql.cnf /etc/mysql/conf.d/00_mysql.cnf \
    && mv /etc/mysql/conf.d/mysqldump.cnf /etc/mysql/conf.d/01_mysqldump.cnf \
    && mv /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/00_mysqld.cnf \
    && mv /etc/mysql/mysql.conf.d/mysqld_safe_syslog.cnf /etc/mysql/mysql.conf.d/01_mysqld_safe_syslog.cnf \
    && sed -i -e "s~log_error~# log_error~g" /etc/mysql/mysql.conf.d/00_mysqld.cnf \
    && sed -i -e "s~bind_address~# bind_address~g" /etc/mysql/mysql.conf.d/00_mysqld.cnf

COPY original_mysql.cnf /etc/mysql/conf.d/02_original_mysql.cnf
COPY original_client.cnf /etc/mysql/conf.d/03_original_client.cnf
COPY original_mysqld.cnf /etc/mysql/mysql.conf.d/02_original_mysqld.cnf

COPY entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["./entrypoint.sh"]