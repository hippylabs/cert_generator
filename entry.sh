#!/usr/bin/env bash

#Change to your company details
country=IN
state=Karnataka
locality=Bangalore
organization="103 Studios Pvt Ltd"
organizationalunit=HippyCam
email=jibin@hhippycam.com
commonname="HippyCam Root CA"

#Optional
password=dummypassword

case $1 in
    gen_ca)
      openssl genrsa -aes256 -passout pass:$password  -out  /crt/ca.key 4096

      openssl rsa -in /crt/ca.key -passin pass:$password -out /crt/ca.key

      openssl req -config openssl.cnf \
            -key /crt/ca.key \
            -new -x509 -days 7300 -sha256 -extensions v3_ca \
            -out /crt/ca.crt \
            -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
    ;;

    gen_crt)
      shift
      commonname=$1
      mkdir -p /crt/$commonname

      openssl genrsa -aes256 \
            -passout pass:$password \
            -out /crt/$commonname/server.key 2048

      openssl rsa -in /crt/$commonname/server.key -passin pass:$password -out /crt/$commonname/server.key

      openssl req -config openssl.cnf \
            -key /crt/$commonname/server.key \
            -new -sha256 -out /crt/$commonname/server.csr \
            -subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/CN=*.$commonname/emailAddress=$email"

      openssl ca -config openssl.cnf -batch \
            -extensions server_cert -days 3750 -notext -md sha256 \
            -in /crt/$commonname/server.csr \
            -out /crt/$commonname/server.crt

      cat /crt/$commonname/server.crt /crt/ca.crt > /crt/$commonname/server.crt.tmp
      mv /crt/$commonname/server.crt.tmp /crt/$commonname/server.crt
      rm /crt/$commonname/server.csr

    ;;

    *)
      echo "Comand not found"
    ;;
esac
