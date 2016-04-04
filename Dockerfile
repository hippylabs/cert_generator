FROM alpine:3.3
RUN apk --update add openssl
WORKDIR /root/ca
RUN mkdir newcerts crt
RUN touch index.txt
RUN echo 1000 > serial
ADD openssl.conf ./openssl.conf
ADD entry.sh ./entry.sh
RUN chmod +x ./entry.sh
ENTRYPOINT ["/root/ca/entry.sh"]
