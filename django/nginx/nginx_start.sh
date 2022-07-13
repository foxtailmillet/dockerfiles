#!/bin/bash

IS_FINISH_SETTING="`grep 'include /etc/nginx/conf.d/\*.conf' /etc/nginx/nginx.conf | wc -l`"
if [ ! "$IS_FINISH_SETTING" == "0" ]; then
    DEBIAN_FRONTEND=noninteractive

    echo "============== nginx initialize =============="

    cd /etc/nginx
    cp nginx.conf nginx.conf.org
    REPLACE_OPTION="-i"
    #REPLACE_OPTION=""
    SEARCH_WORD='    include \/etc\/nginx\/conf.d\/\*.conf;'
    VALUE='\ \ \ \ include \/home\/projects\/nginx\/default.conf;'
    sed $REPLACE_OPTION -e "/${SEARCH_WORD}/a ${VALUE}"        nginx.conf
    sed $REPLACE_OPTION -e "s/${SEARCH_WORD}/#${SEARCH_WORD}/"  nginx.conf
fi


if [ ! -e "/home/projects/nginx" ]; then
    DEBIAN_FRONTEND=noninteractive

    echo "============== nginx default.conf copy =============="

    # prepare dir
    mkdir -p /home/projects/nginx
    cp /home/default.conf.org /home/projects/nginx/default.conf
    sudo chmod 777 /home/projects/nginx/default.conf

    # prepare ssl 
    mkdir -p /home/projects/nginx/ssl
    cd /home/projects/nginx/ssl

    # install openssh
    apt update
    apt install -y openssl
    apt install -y vim

    # create key
    openssl genrsa 2048 > server.key
    openssl rsa -in server.key -out server_no_pass.key

    # create csr
    #C : ２文字の国コード。日本は JP 。(1)
    #ST : 都道府県 (2)
    #L : 市町村 (3)
    #O : 組織の名称 (4)
    #OU : 組織の部局の名前 (5)
    #CN : サーバの FQDN （6）
    SUBJECT="/C=JP"
    SUBJECT="${SUBJECT}/ST=Hokkaido"
    SUBJECT="${SUBJECT}/L=Sapporo"
    SUBJECT="${SUBJECT}/O=(none)"
    SUBJECT="${SUBJECT}/OU=(none)"
    SUBJECT="${SUBJECT}/CN=development"
    openssl req -utf8 -new -key ./server_no_pass.key -out server.csr -subj $SUBJECT

    # create crt
    DAYS=36500
    openssl x509 -days ${DAYS} -req -signkey server_no_pass.key < server.csr > server.crt

fi

echo "#### nginx execute ####"
nginx -g "daemon off;"