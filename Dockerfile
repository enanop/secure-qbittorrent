FROM alpine:latest

ENV HOME="/config" \
XDG_CONFIG_HOME="/config" \
XDG_DATA_HOME="/config"

RUN \
  apk add --no-cache openvpn && \
  apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing qbittorrent-nox && \
  rm -rf /var/cache/apk/*



COPY start.sh /

RUN chmod +x /start.sh

COPY root/ /root

EXPOSE 6881 6881/udp 7070

VOLUME /config /downloads /etc/openvpn/clients

CMD ./start.sh 

