# django テンプレート

django環境のコンテナとエディタ（theia）のコンテナ。
リバースプロキシ用にnginxコンテナも設定。
docker-composeを利用。

## セットアップ

```
git clone http://192.168.1.6:8083/git/dockerfile/django.git
cd django
sudo docker-compose up --no-start # create image, container, network
```

## **start** と **stop**

```
# start
sudo docker-compose start

# stop
sudo docker-compose stop
```

## 作成するサービス

docker-composeのservicesとしてそれぞれを定義。


|コンテナ名|dockerfile（ディレクトリ名）用途|
|----|----|----|
|app          |django  |django動作とソースの配置場所|
|editor       |theia   |エディタ。（ボリュームマッピングでappのソースを編集）|
|sql_editor   |superset|sql実行環境。（supersetのsql labを流用）|
|reverse_proxy|nginx   |リバースプロキシ（nginx）|


### app サービス

djangoコンテナの実行環境。
ソースコード一式はVolumeマッピングでホスト側から参照できる。
デフォルトではデバッグ設定がONになっているので変更結果は自動反映される。

|設定|ホストの値|コンテナ内部の値|
|----|----|----|
|port|8000|8000|
|volume|./work|/home/projects|
|ユーザー|-|user01[uid=1000]|

### editor サービス

djangoのソースコードやその他ツールの設定を参照・編集するためのエディタ（theia）
アクセスはサービスへの直接アクセス（ポート3000番）とリバースプロキシ経由（ポート1080番）の２つを想定。
theiaにユーザー認証機能はないので、インターネット公開する場合はリバースプロキシ経由で何らかの認証＋ssl対応が必要。

|設定|ホストの値|コンテナ内部の値|
|----|----|----|
|port|3000|3000|
|volume|./work|/home/projects|
|ユーザー|-|user01[uid=1000]|

### sql_editor サービス

djangoで使用しているDBの参照・変更用のSQLツール。
supersetに搭載されているSQL Labを使用する想定。（BI機能部分は使うつもりがない）
djangoのDB参照設定は自分で行う。

**[menu]Sources->Databases->右上の「＋」ボタン->各項目を入力してSave->[menu]SQL Labから参照可能**

#### DB接続設定（SQLAlchemy URI）の代表的な例。

|DB              |接続コマンドのインストール           |接続URI                   |
|----|----|----|
|MySQL           |pip install mysqlclient              |mysql://                  |
|Oracle          |pip install cx_Oracle                |oracle://                 |
|PostgreSQL      |pip install psycopg2                 |postgresql+psycopg2://    |
|SQLite          |                                     |sqlite://                 |
|SQL Server      |pip install pymssql                  |mssql://                  |


|設定|ホストの値|コンテナ内部の値|
|----|----|----|
|port|8080|8080|
|volume|./work|/home/projects|
|ユーザー|-|未使用（user01[uid=1000]）|

### reverse_proxy サービス

各種httpサーバーを外部公開するときに使うリバースプロキシ。
SSL設定は含めていない。
必要に応じて事故証明書を作成して設定ファイル（default.conf）を変更する想定。

|設定|ホストの値|コンテナ内部の値|
|----|----|----|
|port|1080|80  |
|volume|./work|/home/projects|

## Volume

各コンテナ共通でホスト側の **./work** ディレクトリをマッピングする。
コンテナ内部でのディレクトリは 全コンテナ共通で **/home/projects** 。

### 構造

コンテナ内部からみたときの構造。
theia用のディレクトリはない。
その代わりtheiaは/home/projects以下を参照できる。（他３コンテナの設定を参照できる）

- /
   - home/
      - projects/
         - mysite/    # djangoが使用する。
         - nginx/     # nginxが使用する。
         - superset/  # supersetが使用する。


### /home/projects/mysite の内部

- /home/projects/mysite/
   - app/             # 作成するアプリケーションはここ
   - mysite/          # このサイト（システム）全体の設定はここ
   - static/          # 静的ファイル（html, css, js, 画像）はここ
   - templates/       # 画面レイアウト（djangoの画面テンプレート）はここ
   - db.sqlite3       # データベースはここ。（sqliteを使う設定になっている）
   - manage.py

### /home/projects/nginx

- /home/projects/nginx
   - default.conf     # nginxのサイト設定。（/etc/nginx/conf.d/default.conf をここに移動している）
   - host.access.log  # アクセスログ（/var/log/nginx/access.log をここに移動している）
   - host.error.log   # エラーログ（var/log/nginx/error.log をここに移動している）
   - (httpasswd)      # デフォルトではファイルなし。必要になったら作成する。（basic認証用の認証情報）

### /home/projects/superset

- /home/projects/superset
   - superset_config.py # supersetの設定。（/root/.superset/superset_config.py をここに移動している）
   - superset.db        # superset本体の動作データ

# その他

## 作業用のdockerコマンドメモ

```
# django環境の試験構築
sudo docker run -it --rm -v "$(pwd)/work:/home/projects" python:3.7.4-buster /bin/bash

# ubuntuの試験環境（apt-get等のテスト）
sudo docker run -it --rm -v "$(pwd)/work:/home/projects" ubuntu:18.04 /bin/bash
```

# 外部環境で利用する場合は初期パスワードを変更・隠ぺいすること。

- superset の初期パスワード（スクリプト内部に記載されている）
