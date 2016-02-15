FROM jordi/openssl
WORKDIR /root/ca
RUN mkdir newcerts crt
RUN touch index.txt
RUN echo 1000 > serial
ADD openssl.cnf ./openssl.cnf
ADD entry.sh ./entry.sh
RUN chmod +x ./entry.sh
ENTRYPOINT ["/root/ca/entry.sh"]
