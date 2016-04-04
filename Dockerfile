FROM alpine:3.3
WORKDIR /root/ca
ADD openssl.conf ./openssl.conf
ADD entry.sh ./entry.sh
RUN apk --update add openssl \
  && mkdir newcerts crt \
  && touch index.txt \
  && echo 1000 > serial \
  && chmod +x ./entry.sh 
ENTRYPOINT ["/root/ca/entry.sh"]
