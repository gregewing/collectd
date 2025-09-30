# Stage 1: Builder
FROM ubuntu:latest AS builder

ENV TZ=Europe/London DEBIAN_FRONTEND=noninteractive

# Enable universe repository and install build deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common wget tar build-essential libtool autoconf automake pkg-config \
        libssl-dev libxml2-dev libcurl4-openssl-dev librrd-dev libpcap-dev libjson-c-dev \
        libprotobuf-c-dev libprotobuf-dev protobuf-compiler libsnmp-dev libmysqlclient-dev libsqlite3-dev && \
    add-apt-repository universe && \
    apt-get update

COPY collectd.conf /config/collectd.conf

# Stage 2: Minimal runtime
FROM ubuntu:25.04

ENV LANG=C.UTF-8 TZ=Europe/London DEBIAN_FRONTEND=noninteractive

# Install only runtime deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        smartmontools lm-sensors && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy collectd from builder
#COPY --from=builder /usr/local/sbin/collectd /usr/local/sbin/
COPY --from=builder /config/collectd.conf /usr/collectd/collectd.conf
#COPY --from=builder /usr/local/bin/collectdctl /usr/local/bin/
COPY scripts /usr/local/bin/

CMD ["collectd", "-f"]
