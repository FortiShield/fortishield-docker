FORTISHIELD_IMAGE_VERSION=5.0.0
FORTISHIELD_VERSION=$(echo $FORTISHIELD_IMAGE_VERSION | sed -e 's/\.//g')
FORTISHIELD_TAG_REVISION=1
FORTISHIELD_CURRENT_VERSION=$(curl --silent https://api.github.com/repos/fortishield/fortishield/releases/latest | grep '\"tag_name\":' | sed -E 's/.*\"([^\"]+)\".*/\1/' | cut -c 2- | sed -e 's/\.//g')
IMAGE_VERSION=${FORTISHIELD_IMAGE_VERSION}

# FortiShield package generator
# Copyright (C) 2023, FortiShield Inc.
#
# This program is a free software; you can redistribute it
# and/or modify it under the terms of the GNU General Public
# License (version 2) as published by the FSF - Free Software
# Foundation.

FORTISHIELD_IMAGE_VERSION="5.0.0"
FORTISHIELD_TAG_REVISION="1"
FORTISHIELD_DEV_STAGE=""
FILEBEAT_MODULE_VERSION="0.4"

# -----------------------------------------------------------------------------

trap ctrl_c INT

clean() {
    exit_code=$1

    exit ${exit_code}
}

ctrl_c() {
    clean 1
}

# -----------------------------------------------------------------------------


build() {

    FORTISHIELD_VERSION="$(echo $FORTISHIELD_IMAGE_VERSION | sed -e 's/\.//g')"
    FILEBEAT_TEMPLATE_BRANCH="${FORTISHIELD_IMAGE_VERSION}"
    FORTISHIELD_FILEBEAT_MODULE="fortishield-filebeat-${FILEBEAT_MODULE_VERSION}.tar.gz"
    FORTISHIELD_UI_REVISION="${FORTISHIELD_TAG_REVISION}"

    if  [ "${FORTISHIELD_DEV_STAGE}" ];then
        FILEBEAT_TEMPLATE_BRANCH="v${FILEBEAT_TEMPLATE_BRANCH}-${FORTISHIELD_DEV_STAGE,,}"
        if ! curl --output /dev/null --silent --head --fail "https://github.com/fortishield/fortishield/tree/${FILEBEAT_TEMPLATE_BRANCH}"; then
            echo "The indicated branch does not exist in the fortishield/fortishield repository: ${FILEBEAT_TEMPLATE_BRANCH}"
            clean 1
        fi
    else
        if curl --output /dev/null --silent --head --fail "https://github.com/fortishield/fortishield/tree/v${FILEBEAT_TEMPLATE_BRANCH}"; then
            FILEBEAT_TEMPLATE_BRANCH="v${FILEBEAT_TEMPLATE_BRANCH}"
        elif curl --output /dev/null --silent --head --fail "https://github.com/fortishield/fortishield/tree/${FILEBEAT_TEMPLATE_BRANCH}"; then
            FILEBEAT_TEMPLATE_BRANCH="${FILEBEAT_TEMPLATE_BRANCH}"
        else
            FORTISHIELD_MASTER_VERSION="$(curl -s https://raw.githubusercontent.com/fortishield/fortishield/master/src/VERSION | sed -e 's/v//g')"
            if [ "${FILEBEAT_TEMPLATE_BRANCH}" == "${FORTISHIELD_MASTER_VERSION}" ]; then
                FILEBEAT_TEMPLATE_BRANCH="master"
            else
                echo "The indicated branch does not exist in the fortishield/fortishield repository: ${FILEBEAT_TEMPLATE_BRANCH}"
                clean 1
            fi
        fi
    fi

    echo FORTISHIELD_VERSION=$FORTISHIELD_IMAGE_VERSION > .env
    echo FORTISHIELD_IMAGE_VERSION=$FORTISHIELD_IMAGE_VERSION >> .env
    echo FORTISHIELD_TAG_REVISION=$FORTISHIELD_TAG_REVISION >> .env
    echo FILEBEAT_TEMPLATE_BRANCH=$FILEBEAT_TEMPLATE_BRANCH >> .env
    echo FORTISHIELD_FILEBEAT_MODULE=$FORTISHIELD_FILEBEAT_MODULE >> .env
    echo FORTISHIELD_UI_REVISION=$FORTISHIELD_UI_REVISION >> .env

    docker-compose -f build-docker-images/build-images.yml --env-file .env build --no-cache

    return 0
}

# -----------------------------------------------------------------------------

help() {
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "    -d, --dev <ref>              [Optional] Set the development stage you want to build, example rc1 or beta1, not used by default."
    echo "    -f, --filebeat-module <ref>  [Optional] Set Filebeat module version. By default ${FILEBEAT_MODULE_VERSION}."
    echo "    -r, --revision <rev>         [Optional] Package revision. By default ${FORTISHIELD_TAG_REVISION}"
    echo "    -v, --version <ver>          [Optional] Set the FortiShield version should be builded. By default, ${FORTISHIELD_IMAGE_VERSION}."
    echo "    -h, --help                   Show this help."
    echo
    exit $1
}

# -----------------------------------------------------------------------------

main() {
    while [ -n "${1}" ]
    do
        case "${1}" in
        "-h"|"--help")
            help 0
            ;;
        "-d"|"--dev")
            if [ -n "${2}" ]; then
                FORTISHIELD_DEV_STAGE="${2}"
                shift 2
            else
                help 1
            fi
            ;;
        "-f"|"--filebeat-module")
            if [ -n "${2}" ]; then
                FILEBEAT_MODULE_VERSION="${2}"
                shift 2
            else
                help 1
            fi
            ;;
        "-r"|"--revision")
            if [ -n "${2}" ]; then
                FORTISHIELD_TAG_REVISION="${2}"
                shift 2
            else
                help 1
            fi
            ;;
        "-v"|"--version")
            if [ -n "$2" ]; then
                FORTISHIELD_IMAGE_VERSION="$2"
                shift 2
            else
                help 1
            fi
            ;;
        *)
            help 1
        esac
    done

    build || clean 1

    clean 0
}

main "$@"
