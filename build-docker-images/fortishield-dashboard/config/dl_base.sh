REPOSITORY="packages.fortishield.com/4.x"
FORTISHIELD_CURRENT_VERSION=$(curl --silent https://api.github.com/repos/fortishield/fortishield/releases/latest | grep '\"tag_name\":' | sed -E 's/.*\"([^\"]+)\".*/\1/' | cut -c 2-)
MAJOR_BUILD=$(echo $FORTISHIELD_VERSION | cut -d. -f1)
MID_BUILD=$(echo $FORTISHIELD_VERSION | cut -d. -f2)
MINOR_BUILD=$(echo $FORTISHIELD_VERSION | cut -d. -f3)
MAJOR_CURRENT=$(echo $FORTISHIELD_CURRENT_VERSION | cut -d. -f1)
MID_CURRENT=$(echo $FORTISHIELD_CURRENT_VERSION | cut -d. -f2)
MINOR_CURRENT=$(echo $FORTISHIELD_CURRENT_VERSION | cut -d. -f3)

## check version to use the correct repository
if [ "$MAJOR_BUILD" -gt "$MAJOR_CURRENT" ]; then
  REPOSITORY="packages-dev.fortishield.com/pre-release"
elif [ "$MAJOR_BUILD" -eq "$MAJOR_CURRENT" ]; then
  if [ "$MID_BUILD" -gt "$MID_CURRENT" ]; then
    REPOSITORY="packages-dev.fortishield.com/pre-release"
  elif [ "$MID_BUILD" -eq "$MID_CURRENT" ]; then
    if [ "$MINOR_BUILD" -gt "$MINOR_CURRENT" ]; then
      REPOSITORY="packages-dev.fortishield.com/pre-release"
    fi
  fi
fi


curl -o fortishield-dashboard-base.tar.xz https://${REPOSITORY}/stack/dashboard/fortishield-dashboard-base-${FORTISHIELD_VERSION}-${FORTISHIELD_TAG_REVISION}-linux-x64.tar.xz
tar -xf fortishield-dashboard-base.tar.xz --directory  $INSTALL_DIR --strip-components=1
