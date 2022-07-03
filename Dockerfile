FROM vault:1.8.12

RUN apk update \
    && apk add bash curl jq

COPY ./init.sh /init.sh
