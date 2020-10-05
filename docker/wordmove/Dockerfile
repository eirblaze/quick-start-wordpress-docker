FROM ruby:2.6-alpine3.11

ENV WM_CFG_DIR /root

RUN apk add --no-cache \
    openssh-server \
    curl \
    rsync \
    php-cli \
    php-mysqli \
    mariadb-client \
    lftp \
    ca-certificates \
    php-phar \
    php-json \
  ; \
  update-ca-certificates; \
  gem install wordmove --version 5.0.2; \
  curl -o /usr/local/bin/wp -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar; \
  chmod +x /usr/local/bin/wp;
# wp cli
#RUN apk add --no-cache phar

COPY ./conf/.lftprc ${WM_CFG_DIR}
COPY ./conf/movefile.yml ${WM_CFG_DIR}
COPY ./conf/wp-cli-config.yml ${WM_CFG_DIR}/.wp-cli/config.yml
COPY ./conf/wp-install.sh ${WM_CFG_DIR}

ENV SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_DIR /etc/ssl/certs

WORKDIR ${WM_CFG_DIR}

# https://qiita.com/watawuwu/items/d547d0cb1ab1db5e079c
# apk add --no-cache ca-certificates && update-ca-certificates
# export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
# export SSL_CERT_DIR=/etc/ssl/certs
