# Quick-start-wordpress-docker

DockerによるWordpressのローカル環境構築を行うためのリポジトリ

## Features

* Dockerによるwordpressのローカル環境構築
* wordmoveへの本番環境デプロイ, バックアップ

## How to start

### 0. 事前準備

本体にdocker, docker-composeをインストール  
以下参考:  
 [Docker Compose - インストール - Qiita](https://qiita.com/zembutsu/items/dd2209a663cae37dfa81)

### 1. 環境変数の設定

このリポジトリをクローン

```sh
git clone git@github.com:eirblaze/quick-start-wordpress-docker.git project-dir
```

.envにdocker-composeで使う環境変数を定義しています。  
コメントを元に記載してください。

```sh
vi ./.env
```

### 2. Dockerコンテナの起動

docker-composeで関連コンテナを起動します。

```sh
docker-compose up -d
```

### 3. Wordpressの初期化

.envのLOCAL_SERVER_PORTに設定したホストにアクセスし、worpdressの初期化を行います

```sh
open https://localhost
```

### 4. Dockerコンテナの停止

docker-composeで関連コンテナを停止します。  

```sh
docker-compose stop
```

### 4. Dockerコンテナの破棄

データベースは 「プロジェクト名_db-data5」 に保存しています

```sh
docker-compose down
```

## wordmove , wp-cli

wordmoveを使えば容易に本番環境とローカル環境の同期が可能です。

### 1. wordmove, wp-cli のコンテナに接続

wordmoveのコンテナを一時的に起動しつつアクセスするコマンドです。

```sh
docker-compose run --rm wordmove ash
```

コンテナ内のデータは永続化されないので、たとえば、DBをダンプするときは、

```sh
wp db export /root/db/dump.sql
```

のように、ホストOSとつないだフォルダにバックアップしてください。

### 2. アップロードの設定

#### SSH を使う場合

コンテナから本番環境に同期するためssh-agentの設定を行います。  
接続先サーバーとのssh接続設定、ローカルのssh/configの設定は終わっていることを前提としてます。  
またid_rsa(秘密鍵)までのパスは接続するサーバーに合わせて記載してください。  
参考:  
[エックスサーバーにSSHで接続してみよう！ | vdeep](http://vdeep.net/xserver-ssh)  
[ssh-agentを利用して、安全にSSH認証を行う - Qiita](https://qiita.com/naoki_mochizuki/items/93ee2643a4c6ab0a20f5)

```sh
# ssh-agentの起動
$ ssh-agent bash

# ssh-agentの登録。
$ ssh-add /home/.ssh/id_rsa

# wordmoveのmysql dumpで使うrubyのエンコーディング
export RUBYOPT=-EUTF-8
```

### 3. 同期・デプロイ

あとはコマンド一発で同期が可能です。  
本番のデータをローカルにバックアップしたい場合は、、  

```sh
wordmove pull --all
```

ローカルのデータを本番にアップロードしたい場合は、、

```sh
wordmove push --all
```

さらにオプション部分の指定で、DBのみthemesのみなど同期内容を変更可能です。  
参考：  
[Wordmoveの基本操作 - Qiita](https://qiita.com/mrymmh/items/c644934cac386d95b7df)

## TODO

- [ ] wordmoveで毎回ssh-addの設定を行う手間を削減（docker-composeのcommandで行う？）

[その他](./todo.md)

## メモ

### なんかごみが残ったとき

`docker-compose build --no-cache`

### windowsでの注意

共有フォルダの調子が悪いとき
    - docker desktop は通常権限
    - docker-compose up するpowershellは管理者権限
