# 使い方 #

$ cd docker-nginx-php

\# イメージを作成  
$ docker build -t <tag>/nginx-php .  

\# 起動  
$ docker run --name web1 -d -p 8081:80 -p 8082:443 -ti <tag>/nginx-php

\# コンテナ内へログイン  
$ docker exec -ti web1 bash 