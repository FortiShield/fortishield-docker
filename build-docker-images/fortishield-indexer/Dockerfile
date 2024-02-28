# FortiShield Docker Copyright (C) 2017, FortiShield Inc. (License GPLv2)
FROM ubuntu:jammy AS builder

ARG FORTISHIELD_VERSION
ARG FORTISHIELD_TAG_REVISION

RUN apt-get update -y && apt-get install curl openssl xz-utils -y

COPY config/opensearch.yml /

COPY config/config.sh .

COPY config/config.yml /

COPY config/action_groups.yml /

COPY config/internal_users.yml /

COPY config/roles_mapping.yml /

COPY config/roles.yml /

RUN bash config.sh

################################################################################
# Build stage 1 (the actual FortiShield indexer image):
#
# Copy fortishield-indexer from stage 0
# Add entrypoint
################################################################################
FROM ubuntu:jammy

ENV USER="fortishield-indexer" \
    GROUP="fortishield-indexer" \
    NAME="fortishield-indexer" \
    INSTALL_DIR="/usr/share/fortishield-indexer"

RUN apt-get update -y && apt-get install curl -y

RUN getent group $GROUP || groupadd -r -g 1000 $GROUP

RUN useradd --system \
            --uid 1000 \
            --no-create-home \
            --home-dir $INSTALL_DIR \
            --gid $GROUP \
            --shell /sbin/nologin \
            --comment "$USER user" \
            $USER

WORKDIR $INSTALL_DIR

COPY config/entrypoint.sh /

COPY config/securityadmin.sh /

COPY config/ism-check.sh /

RUN chmod 700 /entrypoint.sh && chmod 700 /securityadmin.sh && chmod 700 /ism-check.sh

RUN chown 1000:1000 /*.sh

COPY --from=builder --chown=1000:1000 /debian/fortishield-indexer/usr/share/fortishield-indexer /usr/share/fortishield-indexer
COPY --from=builder --chown=0:0 /debian/fortishield-indexer/usr/lib/systemd /usr/lib/systemd
COPY --from=builder --chown=0:0 /debian/fortishield-indexer/usr/lib/sysctl.d /usr/lib/sysctl.d
COPY --from=builder --chown=0:0 /debian/fortishield-indexer/usr/lib/tmpfiles.d /usr/lib/tmpfiles.d

RUN chown -R 1000:1000 /usr/share/fortishield-indexer

RUN mkdir -p /var/lib/fortishield-indexer && chown 1000:1000 /var/lib/fortishield-indexer && \
    mkdir -p /usr/share/fortishield-indexer/logs && chown 1000:1000 /usr/share/fortishield-indexer/logs && \
    mkdir -p /run/fortishield-indexer && chown 1000:1000 /run/fortishield-indexer && \
    mkdir -p /var/log/fortishield-indexer && chown 1000:1000 /var/log/fortishield-indexer && \
    chmod 700 /usr/share/fortishield-indexer && \
    chmod 600 /usr/share/fortishield-indexer/jvm.options && \
    chmod 600 /usr/share/fortishield-indexer/opensearch.yml

USER fortishield-indexer

# Services ports
EXPOSE 9200

ENTRYPOINT ["/entrypoint.sh"]
# Dummy overridable parameter parsed by entrypoint
CMD ["opensearchwrapper"]