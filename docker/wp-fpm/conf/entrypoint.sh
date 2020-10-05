#!/bin/ash

# [独自(root)CA のインストール方法](https://qiita.com/msi/items/9cb90271836386dafce3)
mkdir /usr/share/ca-certificates/mylocal
echo quit | openssl s_client -showcerts -servername local.${PRODUCTION_NAME} -connect local.${PRODUCTION_NAME}:443 > /usr/share/ca-certificates/mylocal/mylocal-root-cacert.crt
echo "mylocal/mylocal-root-cacert.crt" >> /etc/ca-certificates.conf
update-ca-certificates

# [cURLコマンドラインで自己署名証明書を信頼する方法は？](https://www.it-swarm.dev/ja/curl/curl%E3%82%B3%E3%83%9E%E3%83%B3%E3%83%89%E3%83%A9%E3%82%A4%E3%83%B3%E3%81%A7%E8%87%AA%E5%B7%B1%E7%BD%B2%E5%90%8D%E8%A8%BC%E6%98%8E%E6%9B%B8%E3%82%92%E4%BF%A1%E9%A0%BC%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95%E3%81%AF%EF%BC%9F/962723303/)
# curl --cacert /usr/share/ca-certificates/mylocal/cacert.crt --location --silent https://local.${PRODUCTION_NAME}

# [RSA鍵、証明書のファイルフォーマットについて](https://qiita.com/kunichiko/items/12cbccaadcbf41c72735)
# openssl x509 -in /usr/share/ca-certificates/mylocal/cacert.crt -pubkey -noout

# うまくいく方法3: Dockerfile内ですでに一般ユーザーが作られている場合
# [dockerでvolumeをマウントしたときのファイルのowner問題](https://qiita.com/yohm/items/047b2e68d008ebb0f001)
# cat /etc/passwd
# root:x:0:0:root:/root:/bin/ash
# [Alpine Linuxでユーザやグループを追加・修正・削除する](https://amaya382.hatenablog.jp/entry/2017/04/10/104759)
# apk add --no-cache --virtual .builddeps shadow
# usermod -u 0 -o www-data
# groupmod -g 0 -o www-data
# apk del .builddeps

# RUN ; \
#     addgroup -g 0 www-data root

# /var/www/htmlディレクトリのオーナーをwww-dataに変更します。
# [Docker版WordPressのアップデートでFTP画面になってしまうとき ](https://denor.jp/docker%E7%89%88wordpress%E3%81%AE%E3%82%A2%E3%83%83%E3%83%97%E3%83%87%E3%83%BC%E3%83%88%E3%81%A7ftp%E7%94%BB%E9%9D%A2%E3%81%AB%E3%81%AA%E3%81%A3%E3%81%A6%E3%81%97%E3%81%BE%E3%81%86%E3%81%A8%E3%81%8D)
# chown -R www-data.www-data ${WP_HTM_DIR}

# 基本的には、「この.shスクリプトですべてを実行してから、同じシェルでユーザーがコマンドラインで渡すコマンドを実行する」ことを意図しています。
# [What does set -e and exec “$@” do for docker entrypoint scripts?](https://stackoverflow.com/questions/39082768/what-does-set-e-and-exec-do-for-docker-entrypoint-scripts)
exec "$@"
