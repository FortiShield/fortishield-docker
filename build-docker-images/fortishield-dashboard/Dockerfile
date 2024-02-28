# FortiShield Docker Copyright (C) 2017, FortiShield Inc. (License GPLv2)
FROM ubuntu:jammy AS builder

ARG FORTISHIELD_VERSION
ARG FORTISHIELD_TAG_REVISION
ARG INSTALL_DIR=/usr/share/fortishield-dashboard
ARG FORTISHIELD_UI_REVISION

# Update and install dependencies
RUN apt-get update && apt install curl libcap2-bin xz-utils -y

# Create Install dir
RUN mkdir -p $INSTALL_DIR

# Download and extract FortiShield dashboard base
COPY config/dl_base.sh .
RUN bash dl_base.sh

# Generate certificates
COPY config/config.sh .
COPY config/config.yml /
RUN bash config.sh

COPY config/install_fortishield_app.sh /
RUN chmod 775 /install_fortishield_app.sh
RUN bash /install_fortishield_app.sh

# Copy and set permissions to config files
COPY config/opensearch_dashboards.yml $INSTALL_DIR/config/
COPY config/fortishield.yml $INSTALL_DIR/data/fortishield/config/
RUN chown 101:101 $INSTALL_DIR/config/opensearch_dashboards.yml && chmod 664 $INSTALL_DIR/config/opensearch_dashboards.yml

# Create and set permissions to data directories
RUN mkdir -p $INSTALL_DIR/data/fortishield && chown -R 101:101 $INSTALL_DIR/data/fortishield && chmod -R 775 $INSTALL_DIR/data/fortishield
RUN mkdir -p $INSTALL_DIR/data/fortishield/config && chown -R 101:101 $INSTALL_DIR/data/fortishield/config && chmod -R 775 $INSTALL_DIR/data/fortishield/config
RUN mkdir -p $INSTALL_DIR/data/fortishield/logs && chown -R 101:101 $INSTALL_DIR/data/fortishield/logs && chmod -R 775 $INSTALL_DIR/data/fortishield/logs

################################################################################
# Build stage 1 (the current FortiShield dashboard image):
#
# Copy fortishield-dashboard from stage 0
# Add entrypoint
# Add fortishield_app_config
################################################################################
FROM ubuntu:jammy

# Set environment variables
ENV USER="fortishield-dashboard" \
    GROUP="fortishield-dashboard" \
    NAME="fortishield-dashboard" \
    INSTALL_DIR="/usr/share/fortishield-dashboard"

# Set FortiShield app variables
ENV PATTERN="" \
    CHECKS_PATTERN="" \
    CHECKS_TEMPLATE="" \
    CHECKS_API="" \
    CHECKS_SETUP="" \
    EXTENSIONS_PCI="" \
    EXTENSIONS_GDPR="" \
    EXTENSIONS_HIPAA="" \
    EXTENSIONS_NIST="" \
    EXTENSIONS_TSC="" \
    EXTENSIONS_AUDIT="" \
    EXTENSIONS_OSCAP="" \
    EXTENSIONS_CISCAT="" \
    EXTENSIONS_AWS="" \
    EXTENSIONS_GCP="" \
    EXTENSIONS_GITHUB=""\
    EXTENSIONS_OFFICE=""\
    EXTENSIONS_VIRUSTOTAL="" \
    EXTENSIONS_OSQUERY="" \
    EXTENSIONS_DOCKER="" \
    APP_TIMEOUT="" \
    API_SELECTOR="" \
    IP_SELECTOR="" \
    IP_IGNORE="" \
    FORTISHIELD_MONITORING_ENABLED="" \
    FORTISHIELD_MONITORING_FREQUENCY="" \
    FORTISHIELD_MONITORING_SHARDS="" \
    FORTISHIELD_MONITORING_REPLICAS=""

# Create fortishield-dashboard user and group
RUN getent group $GROUP || groupadd -r -g 1000 $GROUP
RUN useradd --system \
            --uid 1000 \
            --no-create-home \
            --home-dir $INSTALL_DIR \
            --gid $GROUP \
            --shell /sbin/nologin \
            --comment "$USER user" \
            $USER

# Copy and set permissions to scripts
COPY config/entrypoint.sh /
COPY config/fortishield_app_config.sh /
RUN chmod 700 /entrypoint.sh
RUN chmod 700 /fortishield_app_config.sh
RUN chown 1000:1000 /*.sh

# Copy Install dir from builder to current image
COPY --from=builder --chown=1000:1000 $INSTALL_DIR $INSTALL_DIR

# Create custom directory
RUN mkdir -p /usr/share/fortishield-dashboard/plugins/fortishield/public/assets/custom
RUN chown 1000:1000 /usr/share/fortishield-dashboard/plugins/fortishield/public/assets/custom

# Set workdir and user
WORKDIR $INSTALL_DIR
USER fortishield-dashboard

# Services ports
EXPOSE 443

ENTRYPOINT [ "/entrypoint.sh" ]
