# docker-nginx-php

### Base Docker Image

[tanaka0323/centosjp](https://bitbucket.org/tanaka0323/docker-centosjp "tanaka0323/centosjp")

### 説明

tanaka0323/centosjpへNginxとPHP5を追加したDockerコンテナイメージです。

[Dockerとは？](https://docs.docker.com/ "Dockerとは？")  
[Docker Command Reference](https://docs.docker.com/reference/commandline/cli/ "Docker Command Reference")

### 使用方法

git pull後に

    $ cd docker-nginx-php

イメージ作成

    $ docker build -t <tag>/nginx-php .

起動

    $ docker run --name <name> -d -p 8081:80 -p 8082:443 -ti <tag>/nginx-php

コンテナ内へログイン

    $ docker exec -ti <name> bash

### 利用可能なボリューム

以下のボリュームが利用可能

    /var/www/html       # ドキュメントルート
    /etc/nginx          # nginx各種設定
    /var/log            # 各種ログ

### Figでの使用方法

[Figとは？](http://www.fig.sh/ "Fidとは？")  

以下はサイト構成サンプル

    web:
      image: tanaka0323/nginx-php
      ports: 
        - "8081:80"
        - "8082:443"
      volumes_from:
        - storage
        - log

    storage:
      image: sitedata
      volumes:
        - /var/www/html
        - /etc/nginx

    log:
      image: tanaka0323/syslog
      volumes:
        - /dev
        - /var/log

