FROM ubuntu:latest
MAINTAINER Greg Ewing (https://github.com/gregewing)
ENV LANG=C.UTF-8 DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/London
COPY scripts /usr/local/bin

RUN echo Stating. \
 && cp /etc/apt/sources.list /etc/apt/sources.list.default \
 && mv /usr/local/bin/sources.list.localrepo /etc/apt/sources.list \
 && apt-get update \
 && apt-get -q -y update \
 && apt-get -q -y install --no-install-recommends smartmontools collectd* libatasmart* libudev* libesmtp* lm-sensors \
 && apt-get -q -y full-upgrade \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && mv /etc/apt/sources.list.default /etc/apt/sources.list \
 && mv /usr/local/bin/collectd.conf /etc/collectd/collectd.conf \
 && echo Finished.

CMD ["collectd", "-f"]
