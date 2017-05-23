FROM golang:1.8.0

EXPOSE 10080
EXPOSE 10443

ADD . /go/src/github.com/sanjayodesk/howsmyssl

RUN go install github.com/sanjayodesk/howsmyssl

# Provided by kubernetes secrets or some such
VOLUME "/secrets"

RUN chown -R www-data /go/src/github.com/sanjayodesk/howsmyssl

USER www-data

CMD ["/bin/bash", "-c", "howsmyssl \   
    -httpsAddr=:10443 \
    -httpAddr=:10080 \
    -adminAddr=:4567 \
    -templateDir=/go/src/github.com/sanjayodesk/howsmyssl/templates \
    -staticDir=/go/src/github.com/sanjayodesk/howsmyssl/static \
    -vhost=howsmyssl.herokuapp.com \
    -acmeRedirect=$ACME_REDIRECT_URL \
    -originsConf=/etc/howsmyssl-origins/origins.json \
    -googAcctConf=/secrets/howsmyssl-logging-svc-account/howsmyssl-logging.json \
    -allowLogName=howsmyssl_allowance_checks \
    -cert=/secrets/howsmyssl-tls/tls.crt \
    -key=/secrets/howsmyssl-tls/tls.key"]
