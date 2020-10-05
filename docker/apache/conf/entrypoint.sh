#!/bin/ash

# うまくいく方法3: Dockerfile内ですでに一般ユーザーが作られている場合
# [dockerでvolumeをマウントしたときのファイルのowner問題](https://qiita.com/yohm/items/047b2e68d008ebb0f001)
# cat /etc/passwd
# root:x:0:0:root:/root:/bin/ash
# [Alpine Linuxでユーザやグループを追加・修正・削除する](https://amaya382.hatenablog.jp/entry/2017/04/10/104759)
apk add --no-cache --virtual .builddeps shadow
usermod -u 0 -o www-data
groupmod -g 0 -o www-data
apk del .builddeps

# RUN ; \
#     addgroup -g 0 www-data root

# /var/www/htmlディレクトリのオーナーをwww-dataに変更します。
# [Docker版WordPressのアップデートでFTP画面になってしまうとき ](https://denor.jp/docker%E7%89%88wordpress%E3%81%AE%E3%82%A2%E3%83%83%E3%83%97%E3%83%87%E3%83%BC%E3%83%88%E3%81%A7ftp%E7%94%BB%E9%9D%A2%E3%81%AB%E3%81%AA%E3%81%A3%E3%81%A6%E3%81%97%E3%81%BE%E3%81%86%E3%81%A8%E3%81%8D)
# chown -R www-data.www-data ${WP_HTM_DIR}
