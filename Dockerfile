FROM docker

COPY run.sh /
COPY codeclimate_defaults /codeclimate_defaults

RUN apk add --no-cache jq

ENTRYPOINT  ["/run.sh"]

CMD ["--help"]
