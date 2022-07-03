FROM bash:5.1

RUN apk update \
    && apk add curl jq

COPY ./init.sh /init.sh
CMD /init.sh
