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

\# イメージを作成  
$ docker build -t "tag"/nginx-php .  

\# 起動  
$ docker run --name web1 -d -p 8081:80 -p 8082:443 -ti "tag"/nginx-php

\# コンテナ内へログイン  
$ docker exec -ti web1 bash