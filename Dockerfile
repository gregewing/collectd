# Stage 1: Build and configure everything
FROM ubuntu:26.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

COPY scripts /usr/local/bin/

RUN apt-get update -q -y \
    && apt-get install -q -y --no-install-recommends \
        smartmontools \
        collectd \
        libmnl0 \
        libatasmart4 \
        libudev1 \
        libesmtp6 \
        lm-sensors \
    && apt -y remove fonts-* \
    && apt-get full-upgrade -q -y \
    && mv /usr/local/bin/collectd.conf /etc/collectd/collectd.conf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Stage 2: Final flattened runtime image
FROM ubuntu:26.04

ENV LANG=C.UTF-8 \
    DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/London

# Copy the entire root filesystem change from the builder stage in exactly ONE layer
COPY --from=builder / /

CMD ["collectd", "-f"]

