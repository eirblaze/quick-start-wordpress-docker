FROM httpd:2.4.41-alpine

#
# 設定ファイル
RUN echo -e "\
Include ${HTTPD_PREFIX}/conf/my-httpd.conf\n\
Include ${HTTPD_PREFIX}/conf/my-php-fpm.conf\n\
Include ${HTTPD_PREFIX}/conf/my-ssi.conf\
" >> $HTTPD_PREFIX/conf/httpd.conf

COPY ./conf/my-httpd.conf $HTTPD_PREFIX/conf/
COPY ./conf/my-php-fpm.conf $HTTPD_PREFIX/conf/
COPY ./conf/my-ssi.conf $HTTPD_PREFIX/conf/

# ユーザー権限付与
# [dockerでvolumeをマウントしたときのファイルのowner問題](https://qiita.com/yohm/items/047b2e68d008ebb0f001)
# COPY ./conf/entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
