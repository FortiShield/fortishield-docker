#!/bin/bash
# FortiShield Docker Copyright (C) 2017, FortiShield Inc. (License GPLv2)

INSTALL_DIR=/usr/share/fortishield-dashboard
DASHBOARD_USERNAME="${DASHBOARD_USERNAME:-kibanaserver}"
DASHBOARD_PASSWORD="${DASHBOARD_PASSWORD:-kibanaserver}"

# Create and configure FortiShield dashboard keystore

yes | $INSTALL_DIR/bin/opensearch-dashboards-keystore create --allow-root && \
echo $DASHBOARD_USERNAME | $INSTALL_DIR/bin/opensearch-dashboards-keystore add opensearch.username --stdin --allow-root && \
echo $DASHBOARD_PASSWORD | $INSTALL_DIR/bin/opensearch-dashboards-keystore add opensearch.password --stdin --allow-root

##############################################################################
# Start FortiShield dashboard
##############################################################################

/fortishield_app_config.sh $FORTISHIELD_UI_REVISION

/usr/share/fortishield-dashboard/bin/opensearch-dashboards -c /usr/share/fortishield-dashboard/config/opensearch_dashboards.yml