FROM alpine:3.9.2

MAINTAINER Joakim Ramer <jramer@me.com>

RUN apk add --no-cache mongodb-tools py2-pip && \
  pip install pymongo awscli && \
  mkdir /backup

ENV S3_PATH=backup AWS_DEFAULT_REGION=eu-west-1 AUTH_DB=admin DB_PORT=27017

COPY entrypoint.sh /usr/local/bin/entrypoint
COPY backup.sh /usr/local/bin/backup

VOLUME /backup

CMD /usr/local/bin/entrypoint
