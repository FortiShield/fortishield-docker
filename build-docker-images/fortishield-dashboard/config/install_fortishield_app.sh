## variables
FORTISHIELD_APP=https://packages.fortishield.com/4.x/ui/dashboard/fortishield-${FORTISHIELD_VERSION}-${FORTISHIELD_UI_REVISION}.zip
FORTISHIELD_CHECK_UPDATES=https://packages.fortishield.com/4.x/ui/dashboard/fortishieldCheckUpdates-${FORTISHIELD_VERSION}-${FORTISHIELD_UI_REVISION}.zip
FORTISHIELD_CORE=https://packages.fortishield.com/4.x/ui/dashboard/fortishieldCore-${FORTISHIELD_VERSION}-${FORTISHIELD_UI_REVISION}.zip
FORTISHIELD_CURRENT_VERSION=$(curl --silent https://api.github.com/repos/fortishield/fortishield/releases/latest | grep '\"tag_name\":' | sed -E 's/.*\"([^\"]+)\".*/\1/' | cut -c 2-)
MAJOR_BUILD=$(echo $FORTISHIELD_VERSION | cut -d. -f1)
MID_BUILD=$(echo $FORTISHIELD_VERSION | cut -d. -f2)
MINOR_BUILD=$(echo $FORTISHIELD_VERSION | cut -d. -f3)
MAJOR_CURRENT=$(echo $FORTISHIELD_CURRENT_VERSION | cut -d. -f1)
MID_CURRENT=$(echo $FORTISHIELD_CURRENT_VERSION | cut -d. -f2)
MINOR_CURRENT=$(echo $FORTISHIELD_CURRENT_VERSION | cut -d. -f3)

## check version to use the correct repository
if [ "$MAJOR_BUILD" -gt "$MAJOR_CURRENT" ]; then
  FORTISHIELD_APP=https://packages-dev.fortishield.com/pre-release/ui/dashboard/fortishield-${FORTISHIELD_VERSION}-${FORTISHIELD_UI_REVISION}.zip
  FORTISHIELD_CHECK_UPDATES=https://packages-dev.fortishield.com/pre-release/ui/dashboard/fortishieldCheckUpdates-${FORTISHIELD_VERSION}-${FORTISHIELD_UI_REVISION}.zip
  FORTISHIELD_CORE=https://packages-dev.fortishield.com/pre-release/ui/dashboard/fortishieldCore-${FORTISHIELD_VERSION}-${FORTISHIELD_UI_REVISION}.zip
elif [ "$MAJOR_BUILD" -eq "$MAJOR_CURRENT" ]; then
  if [ "$MID_BUILD" -gt "$MID_CURRENT" ]; then
    FORTISHIELD_APP=https://packages-dev.fortishield.com/pre-release/ui/dashboard/fortishield-${FORTISHIELD_VERSION}-${FORTISHIELD_UI_REVISION}.zip
    FORTISHIELD_CHECK_UPDATES=https://packages-dev.fortishield.com/pre-release/ui/dashboard/fortishieldCheckUpdates-${FORTISHIELD_VERSION}-${FORTISHIELD_UI_REVISION}.zip
    FORTISHIELD_CORE=https://packages-dev.fortishield.com/pre-release/ui/dashboard/fortishieldCore-${FORTISHIELD_VERSION}-${FORTISHIELD_UI_REVISION}.zip
  elif [ "$MID_BUILD" -eq "$MID_CURRENT" ]; then
    if [ "$MINOR_BUILD" -gt "$MINOR_CURRENT" ]; then
      FORTISHIELD_APP=https://packages-dev.fortishield.com/pre-release/ui/dashboard/fortishield-${FORTISHIELD_VERSION}-${FORTISHIELD_UI_REVISION}.zip
      FORTISHIELD_CHECK_UPDATES=https://packages-dev.fortishield.com/pre-release/ui/dashboard/fortishieldCheckUpdates-${FORTISHIELD_VERSION}-${FORTISHIELD_UI_REVISION}.zip
      FORTISHIELD_CORE=https://packages-dev.fortishield.com/pre-release/ui/dashboard/fortishieldCore-${FORTISHIELD_VERSION}-${FORTISHIELD_UI_REVISION}.zip
    fi
  fi
fi

# Install FortiShield App
$INSTALL_DIR/bin/opensearch-dashboards-plugin install $FORTISHIELD_APP --allow-root
$INSTALL_DIR/bin/opensearch-dashboards-plugin install $FORTISHIELD_CHECK_UPDATES --allow-root
$INSTALL_DIR/bin/opensearch-dashboards-plugin install $FORTISHIELD_CORE --allow-root