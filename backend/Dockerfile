FROM bwstitt/alpine:latest

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]

RUN docker-apk-install \
    curl \
    torsocks

RUN chown abc:abc /etc/tor/torsocks.conf

USER abc

ADD . /
