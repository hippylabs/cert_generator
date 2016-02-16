#!/usr/bin/env bash

#Change to your company details
country=IN
state=Karnataka
locality=Bangalore
organization="103 Studios Pvt Ltd"
organizationalunit=HippyCam
email=jibin@hhippycam.com

#Optional
password=dummypassword

case $1 in
    gen_ca)
      openssl genrsa -aes256 -passout pass:$password  -out  /crt/ca.key 4096

      openssl rsa -in /crt/ca.key -passin pass:$password -out /crt/ca.key

      openssl req -config openssl.conf \
            -key /crt/ca.key \
            -new -x509 -days 7300 -sha256 -extensions v3_ca \
            -out /crt/ca.crt \
            -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=HippyDev Root CA/emailAddress=$email"
    ;;

    gen_crt)
      shift
      domain=$1
      mkdir -p /crt/$domain

      (cat openssl.conf; echo "DNS.3 = $domain"; echo "DNS.4 = *.$domain") > openssl.conf.tmp
      mv openssl.conf.tmp openssl.conf
      cat openssl.conf
      openssl genrsa -aes256 \
            -passout pass:$password \
            -out /crt/$domain/server.key 2048

      openssl rsa -in /crt/$domain/server.key -passin pass:$password -out /crt/$domain/server.key

      openssl req -config openssl.conf \
            -key /crt/$domain/server.key \
            -new -sha256 -out /crt/$domain/server.csr \
            -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=HippyDev/emailAddress=$email"

      openssl ca -config openssl.conf -batch \
            -extensions server_cert -extensions v3_req -days 3750 -notext -md sha256 \
            -in /crt/$domain/server.csr \
            -out /crt/$domain/server.crt

      cat /crt/$domain/server.crt /crt/ca.crt > /crt/$domain/server.crt.tmp
      mv /crt/$domain/server.crt.tmp /crt/$domain/server.crt
      rm /crt/$domain/server.csr

    ;;

    *)
      echo "Comand not found"
    ;;
esac
