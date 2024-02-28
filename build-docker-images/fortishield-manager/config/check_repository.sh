## variables
GPG_SIGN='[arch=amd64 signed-by=/etc/apt/keyrings/fortishield.gpg]'
APT_KEY=https://packages.fortishield.com/key/GPG-KEY-FORTISHIELD
REPOSITORY="deb ${GPG_SIGN} https://packages.fortishield.com/4.x/apt/ stable main"
FORTISHIELD_CURRENT_VERSION=$(curl --silent https://api.github.com/repos/fortishield/fortishield/releases/latest | grep '\"tag_name\":' | sed -E 's/.*\"([^\"]+)\".*/\1/' | cut -c 2-)
MAJOR_BUILD=$(echo $FORTISHIELD_VERSION | cut -d. -f1)
MID_BUILD=$(echo $FORTISHIELD_VERSION | cut -d. -f2)
MINOR_BUILD=$(echo $FORTISHIELD_VERSION | cut -d. -f3)
MAJOR_CURRENT=$(echo $FORTISHIELD_CURRENT_VERSION | cut -d. -f1)
MID_CURRENT=$(echo $FORTISHIELD_CURRENT_VERSION | cut -d. -f2)
MINOR_CURRENT=$(echo $FORTISHIELD_CURRENT_VERSION | cut -d. -f3)

## check version to use the correct repository
if [ "$MAJOR_BUILD" -gt "$MAJOR_CURRENT" ]; then
  APT_KEY=https://packages-dev.fortishield.com/key/GPG-KEY-FORTISHIELD
  REPOSITORY="deb ${GPG_SIGN} https://packages-dev.fortishield.com/pre-release/apt/ unstable main"
elif [ "$MAJOR_BUILD" -eq "$MAJOR_CURRENT" ]; then
  if [ "$MID_BUILD" -gt "$MID_CURRENT" ]; then
    APT_KEY=https://packages-dev.fortishield.com/key/GPG-KEY-FORTISHIELD
    REPOSITORY="deb ${GPG_SIGN} https://packages-dev.fortishield.com/pre-release/apt/ unstable main"
  elif [ "$MID_BUILD" -eq "$MID_CURRENT" ]; then
    if [ "$MINOR_BUILD" -gt "$MINOR_CURRENT" ]; then
      APT_KEY=https://packages-dev.fortishield.com/key/GPG-KEY-FORTISHIELD
      REPOSITORY="deb ${GPG_SIGN} https://packages-dev.fortishield.com/pre-release/apt/ unstable main"
    fi
  fi
fi

curl ${APT_KEY} | gpg --dearmor -o /etc/apt/keyrings/fortishield.gpg
echo ${REPOSITORY} | tee -a /etc/apt/sources.list.d/fortishield.list