#!/bin/bash

#
# This script is meant for quick & easy install via:
#   'curl -sSL https://get.replicated.com/docker | sudo bash'
# or:
#   'wget -qO- https://get.replicated.com/docker | sudo bash'
#
# This script can also be used for upgrades by re-running on same host.
#

set -e

PINNED_DOCKER_VERSION="17.06.2"
MIN_DOCKER_VERSION="1.7.1"
SKIP_DOCKER_INSTALL=0
SKIP_DOCKER_PULL=0
SKIP_OPERATOR_INSTALL=0
IS_MIGRATION=0
NO_PROXY=0
AIRGAP=0
ONLY_INSTALL_DOCKER=0
OPERATOR_TAGS="local"
REPLICATED_USERNAME="replicated"
UI_BIND_PORT="8800"
CONFIGURE_IPV6=0

set +e
read -r -d '' CHANNEL_CSS << CHANNEL_CSS_EOM

CHANNEL_CSS_EOM
set -e


#######################################
#
# common.sh
#
#######################################

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

#######################################
# Check if command exists.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   0 if command exists
#######################################
commandExists() {
    command -v "$@" > /dev/null 2>&1
}

#######################################
# Check if replicated 1.2 is installed
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   0 if replicated 1.2 is installed
#######################################
replicated12Installed() {
    commandExists replicated && replicated --version | grep -q "Replicated version 1\.2"
}

#######################################
# Gets curl or wget depending if cmd exits.
# Globals:
#   PROXY_ADDRESS
# Arguments:
#   None
# Returns:
#   URLGET_CMD
#######################################
URLGET_CMD=
getUrlCmd() {
    if commandExists "curl"; then
        URLGET_CMD="curl -sSL"
        if [ -n "$PROXY_ADDRESS" ]; then
            URLGET_CMD=$URLGET_CMD" -x $PROXY_ADDRESS"
        fi
    else
        URLGET_CMD="wget -qO-"
    fi
}

#######################################
# Generates a 32 char unique id.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   GUID_RESULT
#######################################
getGuid() {
    GUID_RESULT="$(head -c 128 /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)"
}



#######################################
# performs in-place sed substitution with escapting of inputs (http://stackoverflow.com/a/10467453/5344799)
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
function safesed {
    sed -i "s/$(echo $1 | sed -e 's/\([[\/.*]\|\]\)/\\&/g')/$(echo $2 | sed -e 's/[\/&]/\\&/g')/g" $3
}


#######################################
#
# prompt.sh
#
#######################################

PROMPT_RESULT=
READ_TIMEOUT="-t 20"

#######################################
# Confirmation prompt default yes.
# Globals:
#   READ_TIMEOUT
# Arguments:
#   None
# Returns:
#   None
#######################################
confirmY() {
    printf "(Y/n) "
    set +e
    read $READ_TIMEOUT _confirm < /dev/tty
    set -e
    if [ "$_confirm" = "n" ] || [ "$_confirm" = "N" ]; then
        return 1
    fi
    return 0
}

#######################################
# Confirmation prompt default no.
# Globals:
#   READ_TIMEOUT
# Arguments:
#   None
# Returns:
#   None
#######################################
confirmN() {
    printf "(y/N) "
    set +e
    read $READ_TIMEOUT _confirm < /dev/tty
    set -e
    if [ "$_confirm" = "y" ] || [ "$_confirm" = "Y" ]; then
        return 0
    fi
    return 1
}


#######################################
# Prompts the user for input.
# Globals:
#   READ_TIMEOUT
# Arguments:
#   None
# Returns:
#   PROMPT_RESULT
#######################################
prompt() {
    set +e
    read PROMPT_RESULT < /dev/tty
    set -e
}

#######################################
# Prompts the user for input.
# Globals:
#   READ_TIMEOUT
# Arguments:
#   None
# Returns:
#   PROMPT_RESULT
#######################################
promptTimeout() {
    set +e
    read ${1:-$READ_TIMEOUT} PROMPT_RESULT < /dev/tty
    set -e
}

#######################################
#
# system.sh
#
#######################################

#######################################
# Requires a 64 bit platform or exits with an error.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
require64Bit() {
    case "$(uname -m)" in
        *64)
            ;;
        *)
            echo >&2 'Error: you are not using a 64bit platform.'
            echo >&2 'This installer currently only supports 64bit platforms.'
            exit 1
            ;;
    esac
}

#######################################
# Requires that the script be run with the root user.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   USER
#######################################
USER=
requireRootUser() {
    USER="$(id -un 2>/dev/null || true)"
    if [ "$USER" != "root" ]; then
        echo >&2 "Error: This script requires admin privileges. Please re-run it as root."
        exit 1
    fi
}

#######################################
# Detects the linux distribution.
# Upon failure exits with an error.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   LSB_DIST
#   DIST_VERSION
#   DIST_VERSION_MAJOR
#######################################
LSB_DIST=
DIST_VERSION=
DIST_VERSION_MAJOR=
detectLsbDist() {
    _dist=
    _error_msg="We have checked /etc/os-release and /etc/centos-release files."
    if [ -f /etc/os-release ] && [ -r /etc/os-release ]; then
        _dist="$(. /etc/os-release && echo "$ID")"
        _version="$(. /etc/os-release && echo "$VERSION_ID")"
    elif [ -f /etc/centos-release ] && [ -r /etc/centos-release ]; then
        # this is a hack for CentOS 6
        _dist="$(cat /etc/centos-release | cut -d" " -f1)"
        _version="$(cat /etc/centos-release | cut -d" " -f3 | cut -d "." -f1)"
    elif [ -f /etc/redhat-release ] && [ -r /etc/redhat-release ]; then
        # this is for RHEL6
        _dist="rhel"
        _major_version=$(cat /etc/redhat-release | cut -d" " -f7 | cut -d "." -f1)
        _minor_version=$(cat /etc/redhat-release | cut -d" " -f7 | cut -d "." -f2)
        _version=$_major_version
    elif [ -f /etc/system-release ] && [ -r /etc/system-release ]; then
        if grep --quiet "Amazon Linux" /etc/system-release; then
            # Special case for Amazon 2014.03
            _dist="amzn"
            _version=`awk '/Amazon Linux/{print $NF}' /etc/system-release`
        fi
    else
        _error_msg="$_error_msg\nDistribution cannot be determined because neither of these files exist."
    fi

    if [ -n "$_dist" ]; then
        _error_msg="$_error_msg\nDetected distribution is ${_dist}."
        _dist="$(echo "$_dist" | tr '[:upper:]' '[:lower:]')"
        case "$_dist" in
            ubuntu)
                _error_msg="$_error_msg\nHowever detected version $_version is less than 12."
                oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS";
                [ $1 -ge 12 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
                ;;
            debian)
                _error_msg="$_error_msg\nHowever detected version $_version is less than 7."
                oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS";
                [ $1 -ge 7 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
                ;;
            fedora)
                _error_msg="$_error_msg\nHowever detected version $_version is less than 21."
                oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS";
                [ $1 -ge 21 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
                ;;
            rhel)
                _error_msg="$_error_msg\nHowever detected version $_version is less than 7."
                oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS";
                [ $1 -ge 6 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
                ;;
            centos)
                _error_msg="$_error_msg\nHowever detected version $_version is less than 6."
                oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS";
                [ $1 -ge 6 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
                ;;
            amzn)
                _error_msg="$_error_msg\nHowever detected version $_version is not one of 2017.03, 2016.09, 2016.03, 2015.09, 2015.03, 2014.09, 2014.03."
                [ "$_version" = "2017.03" ] || \
                [ "$_version" = "2016.03" ] || [ "$_version" = "2016.09" ] || \
                [ "$_version" = "2015.03" ] || [ "$_version" = "2015.09" ] || \
                [ "$_version" = "2014.03" ] || [ "$_version" = "2014.09" ] && \
                LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$_version
                ;;
            sles)
                _error_msg="$_error_msg\nHowever detected version $_version is less than 12."
                oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS";
                [ $1 -ge 12 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
                ;;
            ol)
                _error_msg="$_error_msg\nHowever detected version $_version is less than 6."
                oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS";
                [ $1 -ge 6 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
                ;;
            *)
                _error_msg="$_error_msg\nThat is an unsupported distribution."
                ;;
        esac
    fi

    if [ -z "$LSB_DIST" ]; then
        echo >&2 "$(echo | sed "i$_error_msg")"
        echo >&2 ""
        echo >&2 "Please visit the following URL for more detailed installation instructions:"
        echo >&2 ""
        echo >&2 "  https://www.replicated.com/docs/distributing-an-application/installing/"
        exit 1
    fi
}

#######################################
# Detects the init system.
# Upon failure exits with an error.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   INIT_SYSTEM
#######################################
INIT_SYSTEM=
detectInitSystem() {
    if [[ "$(/sbin/init --version 2>/dev/null)" =~ upstart ]]; then
        INIT_SYSTEM=upstart
    elif [[ "$(systemctl 2>/dev/null)" =~ -\.mount ]]; then
        INIT_SYSTEM=systemd
    elif [ -f /etc/init.d/cron ] && [ ! -h /etc/init.d/cron ]; then
        INIT_SYSTEM=sysvinit
    else
        echo >&2 "Error: failed to detect init system or unsupported."
        exit 1
    fi
}

#######################################
#
# docker.sh
#
# require common.sh, system.sh
#
#######################################

RESTART_DOCKER=0

#######################################
# Starts docker.
# Globals:
#   LSB_DIST
#   INIT_SYSTEM
# Arguments:
#   None
# Returns:
#   None
#######################################
startDocker() {
    if [ "$LSB_DIST" = "amzn" ]; then
        service docker start
        return
    fi
    case "$INIT_SYSTEM" in
        systemd)
            systemctl enable docker
            systemctl start docker
            ;;
        upstart|sysvinit)
            service docker start
            ;;
    esac
}

#######################################
# Restarts docker.
# Globals:
#   LSB_DIST
#   INIT_SYSTEM
# Arguments:
#   None
# Returns:
#   None
#######################################
restartDocker() {
    if [ "$LSB_DIST" = "amzn" ]; then
        service docker restart
        return
    fi
    case "$INIT_SYSTEM" in
        systemd)
            systemctl daemon-reload
            systemctl restart docker
            ;;
        upstart|sysvinit)
            service docker restart
            ;;
    esac
}

#######################################
# Checks support for docker driver.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
checkDockerDriver() {
    if ! commandExists "docker"; then
        echo >&2 "Error: docker is not installed."
        exit 1
    fi

    if [ "$(ps -ef | grep "docker" | grep -v "grep" | wc -l)" = "0" ]; then
        startDocker
    fi

    _driver=$(docker info 2>/dev/null | grep 'Execution Driver' | awk '{print $3}' | awk -F- '{print $1}')
    if [ "$_driver" = "lxc" ]; then
        echo >&2 "Error: the running Docker daemon is configured to use the '${_driver}' execution driver."
        echo >&2 "This installer only supports the 'native' driver (AKA 'libcontainer')."
        echo >&2 "Check your Docker daemon options."
        exit 1
    fi
}

#######################################
# Checks support for docker storage driver.
# Globals:
#   BYPASS_STORAGEDRIVER_WARNINGS
# Arguments:
#   None
# Returns:
#   None
#######################################
BYPASS_STORAGEDRIVER_WARNINGS=
checkDockerStorageDriver() {
    if [ "$BYPASS_STORAGEDRIVER_WARNINGS" = "1" ]; then
        return
    fi

    if ! commandExists "docker"; then
        echo >&2 "Error: docker is not installed."
        exit 1
    fi

    if [ "$(ps -ef | grep "docker" | grep -v "grep" | wc -l)" = "0" ]; then
        startDocker
    fi

    _driver=$(docker info 2>/dev/null | grep 'Storage Driver' | awk '{print $3}' | awk -F- '{print $1}')
    if [ "$_driver" = "devicemapper" ] && docker info 2>/dev/null | grep -Fqs 'Data loop file:' ; then
        printf "${RED}The running Docker daemon is configured to use the 'devicemapper' storage driver \
in loopback mode.\nThis is not recommended for production use. Please see to the following URL for more \
information.\n\nhttps://www.replicated.com/docs/kb/developer-resources/devicemapper-warning/.${NC}\n\n\
Do you want to proceed anyway? "
        if ! confirmN; then
            exit 0
        fi
    fi
}

#######################################
# Get the docker group ID.
# Default to 0 for root group.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   DOCKER_GROUP_ID
#   None
#######################################
DOCKER_GROUP_ID=0
detectDockerGroupId() {
    # Parse the docker group from the docker.sock file
    # On most systems this will be a group called `docker`
    if [ -e /var/run/docker.sock ]; then
        DOCKER_GROUP_ID="$(stat -c '%g' /var/run/docker.sock)"
    # If the docker.sock file doesn't fall back to the docker group.
    elif [ "$(getent group docker)" ]; then
        DOCKER_GROUP_ID="$(getent group docker | cut -d: -f3)"
    fi
}

#######################################
#
# docker-version.sh
#
# require common.sh, system.sh
#
#######################################

#######################################
# Gets docker server version.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   DOCKER_VERSION
#######################################
DOCKER_VERSION=
getDockerVersion() {
    if ! commandExists "docker"; then
        return
    fi

    DOCKER_VERSION=$(docker -v | awk '{gsub(/,/, "", $3); print $3}')
}

#######################################
# Parses docker version.
# Globals:
#   None
# Arguments:
#   Docker Version
# Returns:
#   DOCKER_VERSION_MAJOR
#   DOCKER_VERSION_MINOR
#   DOCKER_VERSION_PATCH
#   DOCKER_VERSION_RELEASE
#######################################
DOCKER_VERSION_MAJOR=
DOCKER_VERSION_MINOR=
DOCKER_VERSION_PATCH=
DOCKER_VERSION_RELEASE=
parseDockerVersion() {
    # reset
    DOCKER_VERSION_MAJOR=
    DOCKER_VERSION_MINOR=
    DOCKER_VERSION_PATCH=
    DOCKER_VERSION_RELEASE=
    if [ -z "$1" ]; then
        return
    fi

    OLD_IFS="$IFS" && IFS=. && set -- $1 && IFS="$OLD_IFS"
    DOCKER_VERSION_MAJOR=$1
    DOCKER_VERSION_MINOR=$2
    OLD_IFS="$IFS" && IFS=- && set -- $3 && IFS="$OLD_IFS"
    DOCKER_VERSION_PATCH=$1
    DOCKER_VERSION_RELEASE=$2
}

#######################################
# Compare two docker versions.
# Returns -1 if A lt B, 0 if eq, 1 A gt B.
# Globals:
#   None
# Arguments:
#   Docker Version A
#   Docker Version B
# Returns:
#   COMPARE_DOCKER_VERSIONS_RESULT
#######################################
COMPARE_DOCKER_VERSIONS_RESULT=
compareDockerVersions() {
    # reset
    COMPARE_DOCKER_VERSIONS_RESULT=
    parseDockerVersion "$1"
    _a_major="$DOCKER_VERSION_MAJOR"
    _a_minor="$DOCKER_VERSION_MINOR"
    _a_patch="$DOCKER_VERSION_PATCH"
    parseDockerVersion "$2"
    _b_major="$DOCKER_VERSION_MAJOR"
    _b_minor="$DOCKER_VERSION_MINOR"
    _b_patch="$DOCKER_VERSION_PATCH"
    if [ "$_a_major" -lt "$_b_major" ]; then
        COMPARE_DOCKER_VERSIONS_RESULT=-1
        return
    fi
    if [ "$_a_major" -gt "$_b_major" ]; then
        COMPARE_DOCKER_VERSIONS_RESULT=1
        return
    fi
    if [ "$_a_minor" -lt "$_b_minor" ]; then
        COMPARE_DOCKER_VERSIONS_RESULT=-1
        return
    fi
    if [ "$_a_minor" -gt "$_b_minor" ]; then
        COMPARE_DOCKER_VERSIONS_RESULT=1
        return
    fi
    if [ "$_a_patch" -lt "$_b_patch" ]; then
        COMPARE_DOCKER_VERSIONS_RESULT=-1
        return
    fi
    if [ "$_a_patch" -gt "$_b_patch" ]; then
        COMPARE_DOCKER_VERSIONS_RESULT=1
        return
    fi
    COMPARE_DOCKER_VERSIONS_RESULT=0
}

#######################################
# Get max docker version for lsb dist/version.
# Globals:
#   LSB_DIST
# Arguments:
#   None
# Returns:
#   MAX_DOCKER_VERSION_RESULT
#######################################
MAX_DOCKER_VERSION_RESULT=
getMaxDockerVersion() {
    # Max Docker version on CentOS 6 is 1.7.1.
    if [ "$LSB_DIST" = "centos" ]; then
        if [ "$DIST_VERSION_MAJOR" = "6" ]; then
            MAX_DOCKER_VERSION_RESULT="1.7.1"
        fi
    fi
    # Max Docker version on RHEL 6 is 1.7.1.
    if [ "$LSB_DIST" = "rhel" ]; then
        if [ "$DIST_VERSION_MAJOR" = "6" ]; then
            MAX_DOCKER_VERSION_RESULT="1.7.1"
        fi
    fi
    # Max Docker version on Fedora 21 is 1.9.1.
    if [ "$LSB_DIST" = "fedora" ]; then
        if [ "$DIST_VERSION_MAJOR" = "21" ]; then
            MAX_DOCKER_VERSION_RESULT="1.9.1"
        fi
    fi
    # Max Docker version on Ubuntu 15.04 is 1.9.1.
    if [ "$LSB_DIST" = "ubuntu" ]; then
        if [ "$DIST_VERSION" = "15.04" ]; then
            MAX_DOCKER_VERSION_RESULT="1.9.1"
        fi
    fi
    # Amazon has their own repo and 12.6.0 and 17.03.1 are available there for now.
    if [ "$LSB_DIST" = "amzn" ]; then
        MAX_DOCKER_VERSION_RESULT="17.03.1"
    fi
    # Max Docker version on SUSE Linux Enterprise Server 12 SP1 is 1.12.6.
    if [ "$LSB_DIST" = "sles" ]; then
        MAX_DOCKER_VERSION_RESULT="1.12.6"
    fi
    # Max Docker version on Oracle Linux 6.x seems to be 17.03.1.
    if [ "$LSB_DIST" = "ol" ]; then
        if [ "$DIST_VERSION_MAJOR" = "6" ]; then
            MAX_DOCKER_VERSION_RESULT="17.03.1"
        fi
    fi
}

#######################################
#
# docker-install.sh
#
# require common.sh, prompt.sh, system.sh, docker-version.sh
#
#######################################

#######################################
# Installs requested docker version.
# Requires at least min docker version to proceed.
# Globals:
#   LSB_DIST
#   INIT_SYSTEM
#   AIRGAP
# Arguments:
#   Requested Docker Version
#   Minimum Docker Version
# Returns:
#   DID_INSTALL_DOCKER
#######################################
DID_INSTALL_DOCKER=0
installDocker() {
    _dockerGetBestVersion "$1"

    if ! commandExists "docker"; then
        _dockerRequireMinInstallableVersion "$2"
        _installDocker "$BEST_DOCKER_VERSION_RESULT"
        return
    fi

    getDockerVersion

    compareDockerVersions "$DOCKER_VERSION" "$2"
    if [ "$COMPARE_DOCKER_VERSIONS_RESULT" -eq "-1" ]; then
        _dockerRequireMinInstallableVersion "$2"
        _dockerForceUpgrade "$BEST_DOCKER_VERSION_RESULT"
    else
        compareDockerVersions "$DOCKER_VERSION" "$BEST_DOCKER_VERSION_RESULT"
        if [ "$COMPARE_DOCKER_VERSIONS_RESULT" -eq "-1" ]; then
            _dockerUpgrade "$BEST_DOCKER_VERSION_RESULT"
            if [ "$DID_INSTALL_DOCKER" -ne "1" ]; then
                _dockerProceedAnyway
            fi
        elif [ "$COMPARE_DOCKER_VERSIONS_RESULT" -eq "1" ]; then
            _dockerProceedAnyway "$BEST_DOCKER_VERSION_RESULT"
        fi
        # The system has the exact pinned version installed.
        # No need to run the Docker install script.
    fi
}

_installDocker() {
    if [ "$LSB_DIST" = "amzn" ]; then
        # Docker install script no longer supports Amazon Linux
        printf "${GREEN}Installing docker from Yum repository${NC}\n"
        # 1.12.6 and 17.03.1ce are available
        compareDockerVersions "17.0.0" "${1}"
        # if docker version is ce
        if [ "$COMPARE_DOCKER_VERSIONS_RESULT" -eq "-1" ]; then
            yum -y -q install docker-17.03.1ce
        else
            yum -y -q install docker-1.12.6
        fi
        service docker start || true
        DID_INSTALL_DOCKER=1
        return
    elif [ "$LSB_DIST" = "sles" ]; then
        # Docker install script no longer supports SUSE
        printf "${GREEN}Installing docker from Zypper repository${NC}\n"
        sudo zypper -n install "docker=${1}"
        service docker start || true
        DID_INSTALL_DOCKER=1
        return
    fi

    _docker_install_url="https://get.replicated.com/docker-install.sh"
    printf "${GREEN}Installing docker from ${_docker_install_url}${NC}\n"
    getUrlCmd
    $URLGET_CMD "$_docker_install_url?docker_version=${1}&lsb_dist=${LSB_DIST}&dist_version=${DIST_VERSION_MAJOR}" > /tmp/docker_install.sh
    # When this script is piped into bash as stdin, apt-get will eat the remaining parts of this script,
    # preventing it from being executed.  So using /dev/null here to change stdin for the docker script.
    sh /tmp/docker_install.sh < /dev/null

    printf "${GREEN}External script is finished${NC}\n"

    # Need to manually start Docker in these cases
    if [ "$INIT_SYSTEM" = "systemd" ]; then
        systemctl enable docker
        systemctl start docker
    elif [ "$LSB_DIST" = "centos" ]; then
        if [ "$(cat /etc/centos-release | cut -d" " -f3 | cut -d "." -f1)" = "6" ]; then
            service docker start
        fi
    fi
    DID_INSTALL_DOCKER=1
}

_dockerUpgrade() {
    if [ "$AIRGAP" != "1" ]; then
        printf "This installer will upgrade your current version of Docker (%s) to the recommended version: %s\n" "$DOCKER_VERSION" "$1"
        printf "Do you want to allow this? "
        if confirmY; then
            _installDocker "$1"
            return
        fi
    fi
}

_dockerForceUpgrade() {
    if [ "$AIRGAP" -eq "1" ]; then
        echo >&2 "Error: The installed version of Docker ($DOCKER_VERSION) may not be compatible with this installer."
        echo >&2 "Please manually upgrade your current version of Docker to the recommended version: $1"
        exit 1
    fi

    _dockerUpgrade "$1"
    if [ "$DID_INSTALL_DOCKER" -ne "1" ]; then
        printf "Please manually upgrade your current version of Docker to the recommended version: %s\n" "$1"
        exit 0
    fi
}

_dockerProceedAnyway() {
    printf "The installed version of Docker (%s) may not be compatible with this installer.\nThe recommended version is %s\n" "$DOCKER_VERSION" "$1"
    printf "Do you want to proceed anyway? "
    if ! confirmN; then
        exit 0
    fi
}

_dockerGetBestVersion() {
    BEST_DOCKER_VERSION_RESULT="$1"
    getMaxDockerVersion
    if [ -n "$MAX_DOCKER_VERSION_RESULT" ]; then
        compareDockerVersions "$BEST_DOCKER_VERSION_RESULT" "$MAX_DOCKER_VERSION_RESULT"
        if [ "$COMPARE_DOCKER_VERSIONS_RESULT" -eq "1" ]; then
            BEST_DOCKER_VERSION_RESULT="$MAX_DOCKER_VERSION_RESULT"
        fi
    fi
}

_dockerRequireMinInstallableVersion() {
    getMaxDockerVersion
    if [ -z "$MAX_DOCKER_VERSION_RESULT" ]; then
        return
    fi

    compareDockerVersions "$1" "$MAX_DOCKER_VERSION_RESULT"
    if [ "$COMPARE_DOCKER_VERSIONS_RESULT" -eq "1" ]; then
        echo >&2 "Error: This install script may not be compatible with this linux distribution."
        echo >&2 "We have detected a maximum docker version of $MAX_DOCKER_VERSION_RESULT while the required minimum version for this script is $1."
        exit 1
    fi
}

#######################################
#
# replicated.sh
#
# require prompt.sh
#
#######################################

#######################################
# Reads a value from the /etc/replicated.conf file
# Globals:
#   None
# Arguments:
#   Variable to read
# Returns:
#   REPLICATED_CONF_VALUE
#######################################
readReplicatedConf() {
    unset REPLICATED_CONF_VALUE
    if [ -f /etc/replicated.conf ]; then
        REPLICATED_CONF_VALUE=$(cat /etc/replicated.conf | grep -o "\"$1\":\s*\"[^\"]*" | sed "s/\"$1\":\s*\"//") || true
    fi
}

#######################################
# Prompts for daemon endpoint if not already set.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   DAEMON_ENDPOINT
#######################################
DAEMON_ENDPOINT=
promptForDaemonEndpoint() {
    if [ -n "$DAEMON_ENDPOINT" ]; then
        return
    fi

    printf "Please enter the 'Daemon Address' displayed on the 'Cluster' page of your On-Prem Console.\n"
    while true; do
        printf "Daemon Address: "
        prompt
        if [ -n "$PROMPT_RESULT" ]; then
            DAEMON_ENDPOINT="$PROMPT_RESULT"
            return
        fi
    done
}

#######################################
# Prompts for daemon token if not already set.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   DAEMON_TOKEN
#######################################
DAEMON_TOKEN=
promptForDaemonToken() {
    if [ -n "$DAEMON_TOKEN" ]; then
        return
    fi

    printf "Please enter the 'Secret Token' displayed on the 'Cluster' page of your On-Prem Console.\n"
    while true; do
        printf "Secret Token: "
        prompt
        if [ -n "$PROMPT_RESULT" ]; then
            DAEMON_TOKEN="$PROMPT_RESULT"
            return
        fi
    done
}

#######################################
# Prompts for daemon token if not already set.
# Globals:
#   REPLICATED_USERNAME
# Arguments:
#   None
# Returns:
#   REPLICATED_USER_ID
#######################################
REPLICATED_USER_ID=0
maybeCreateReplicatedUser() {
    # require REPLICATED_USERNAME
    if [ -z "$REPLICATED_USERNAME" ]; then
        return
    fi

    # Create the users
    REPLICATED_USER_ID=$(id -u "$REPLICATED_USERNAME" 2>/dev/null || true)
    if [ -z "$REPLICATED_USER_ID" ]; then
        useradd -g "${DOCKER_GROUP_ID:-0}" "$REPLICATED_USERNAME"
        REPLICATED_USER_ID=$(id -u "$REPLICATED_USERNAME")
    fi

    # Add the users to the docker group if needed
    # Versions older than 2.5.0 run as root
    if [ "$REPLICATED_USER_ID" != "0" ]; then
        usermod -a -G "${DOCKER_GROUP_ID:-0}" "$REPLICATED_USERNAME"
    fi
}

#######################################
#
# cli-script.sh
#
#######################################

#######################################
# Writes the replicated CLI to /usr/local/bin/replicated
# Wtires the replicated CLI V2 to /usr/local/bin/replicatedctl
# Globals:
#   None
# Arguments:
#   Container name/ID or script that identifies the container to run the commands in
# Returns:
#   None
#######################################
installCLIFile() {
  cat > /usr/local/bin/replicated <<-EOF
#!/bin/sh

# test if stdin is a terminal
if [ -t 0 ]; then
  sudo docker exec -it ${1} replicated "\$@"
elif [ -t 1 ]; then
  sudo docker exec -i ${1} replicated "\$@"
else
  sudo docker exec ${1} replicated "\$@"
fi
EOF
  chmod a+x /usr/local/bin/replicated
  cat > /usr/local/bin/replicatedctl <<-EOF
#!/bin/sh

# test if stdin is a terminal
if [ -t 0 ]; then
  sudo docker exec -it ${1} replicatedctl "\$@"
elif [ -t 1 ]; then
  sudo docker exec -i ${1} replicatedctl "\$@"
else
  sudo docker exec ${1} replicatedctl "\$@"
fi
EOF
  chmod a+x /usr/local/bin/replicatedctl
}

#######################################
#
# alias.sh
#
# require common.sh
#
#######################################

#######################################
# Writes the alias command to the /etc/replicated.alias file
# Globals:
#   None
# Arguments:
#   Alias to write
# Returns:
#   REPLICATED_CONF_VALUE
#######################################
installAliasFile() {
    # "replicated" is no longer an alias, and we need to remove it from the file.
    # And we still need to create this file so replicated can write app aliases here.
    requireAliasFile

    _match="alias replicated=\".*\""
    if grep -q -s "$_match" /etc/replicated.alias; then
        # Replace in case we switched tags
        sed -i "s#$_match##" /etc/replicated.alias
    fi

    installAliasBashrc
}

#######################################
# Creates the /etc/replicated.alias file if it does not exist
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
requireAliasFile() {
    # Old script might have mounted this file when it didn't exist, and now it's a folder.
    if [ -d /etc/replicated.alias ]; then
        rm -rf /etc/replicated.alias
    fi
    if [ ! -e /etc/replicated.alias ]; then
        echo "# THIS FILE IS GENERATED BY REPLICATED. DO NOT EDIT!" > /etc/replicated.alias
    fi
}

#######################################
# Sources the /etc/replicated.alias file in the .bashrc
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
installAliasBashrc() {
    bashrc_file=
    if [ -f /etc/bashrc ]; then
        bashrc_file="/etc/bashrc"
    elif [ -f /etc/bash.bashrc ]; then
        bashrc_file="/etc/bash.bashrc"
    else
        echo "${RED}No global bashrc file found. Replicated command aliasing will be disabled.${NC}"
    fi

    if [ -n "$bashrc_file" ]; then
        if ! grep -q "/etc/replicated.alias" "$bashrc_file"; then
            cat >> "$bashrc_file" <<-EOF

if [ -f /etc/replicated.alias ]; then
    . /etc/replicated.alias
fi
EOF
        fi
    fi
}

#######################################
#
# ip-address.sh
#
# require common.sh, prompt.sh
#
#######################################

PRIVATE_ADDRESS=
PUBLIC_ADDRESS=

#######################################
# Prompts the user for a private address.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   PRIVATE_ADDRESS
#######################################
promptForPrivateIp() {
    _count=0
    _regex="^[[:digit:]]+: ([^[:space:]]+)[[:space:]]+[[:alnum:]]+ ([[:digit:].]+)"
    while read -r _line; do
        [[ $_line =~ $_regex ]]
        if [ "${BASH_REMATCH[1]}" != "lo" ]; then
            _iface_names[$((_count))]=${BASH_REMATCH[1]}
            _iface_addrs[$((_count))]=${BASH_REMATCH[2]}
            let "_count += 1"
        fi
    done <<< "$(ip -4 -o addr)"
    if [ "$_count" -eq "0" ]; then
        echo >&2 "Error: The installer couldn't discover any valid network interfaces on this machine."
        echo >&2 "Check your network configuration and re-run this script again."
        echo >&2 "If you want to skip this discovery process, pass the 'local-address' arg to this script, e.g. 'sudo ./install.sh local-address=1.2.3.4'"
        exit 1
    elif [ "$_count" -eq "1" ]; then
        PRIVATE_ADDRESS=${_iface_addrs[0]}
        printf "The installer will use network interface '%s' (with IP address '%s')\n" "${_iface_names[0]}" "${_iface_addrs[0]}"
        return
    fi
    printf "The installer was unable to automatically detect the private IP address of this machine.\n"
    printf "Please choose one of the following network interfaces:\n"
    for i in $(seq 0 $((_count-1))); do
        printf "[%d] %-5s\t%s\n" "$i" "${_iface_names[$i]}" "${_iface_addrs[$i]}"
    done
    while true; do
        printf "Enter desired number (0-%d): " "$((_count-1))"
        prompt
        if [ -z "$PROMPT_RESULT" ]; then
            continue
        fi
        if [ "$PROMPT_RESULT" -ge "0" ] && [ "$PROMPT_RESULT" -lt "$_count" ]; then
            PRIVATE_ADDRESS=${_iface_addrs[$PROMPT_RESULT]}
            printf "The installer will use network interface '%s' (with IP address '%s').\n" "${_iface_names[$PROMPT_RESULT]}" "$PRIVATE_ADDRESS"
            return
        fi
    done
}

#######################################
# Discovers public IP address from cloud provider metadata services.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   PUBLIC_ADDRESS
#######################################
discoverPublicIp() {
    if [ -n "$PUBLIC_ADDRESS" ]; then
        printf "The installer will use service address '%s' (from parameter)\n" "$PUBLIC_ADDRESS"
        return
    fi

    # gce
    if commandExists "curl"; then
        set +e
        _out=$(curl --noproxy "*" --max-time 5 --connect-timeout 2 -qSfs -H 'Metadata-Flavor: Google' http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip 2>/dev/null)
        _status=$?
        set -e
    else
        set +e
        _out=$(wget --no-proxy -t 1 --timeout=5 --connect-timeout=2 -qO- --header='Metadata-Flavor: Google' http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip 2>/dev/null)
        _status=$?
        set -e
    fi
    if [ "$_status" -eq "0" ] && [ -n "$_out" ]; then
        PUBLIC_ADDRESS=$_out
        printf "The installer will use service address '%s' (discovered from GCE metadata service)\n" "$PUBLIC_ADDRESS"
        return
    fi

    # ec2
    if commandExists "curl"; then
        set +e
        _out=$(curl --noproxy "*" --max-time 5 --connect-timeout 2 -qSfs http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null)
        _status=$?
        set -e
    else
        set +e
        _out=$(wget --no-proxy -t 1 --timeout=5 --connect-timeout=2 -qO- http://169.254.169.254/latest/meta-data/public-ipv4 2>/dev/null)
        _status=$?
        set -e
    fi
    if [ "$_status" -eq "0" ] && [ -n "$_out" ]; then
        PUBLIC_ADDRESS=$_out
        printf "The installer will use service address '%s' (discovered from EC2 metadata service)\n" "$PUBLIC_ADDRESS"
        return
    fi
}

#######################################
# Prompts the user for a public address.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   PUBLIC_ADDRESS
#######################################
shouldUsePublicIp() {
    if [ -z "$PUBLIC_ADDRESS" ]; then
        return
    fi

    printf "The installer has automatically detected the service IP address of this machine as %s.\n" "$PUBLIC_ADDRESS"
    printf "Do you want to:\n"
    printf "[0] default: use %s\n" "$PUBLIC_ADDRESS"
    printf "[1] enter new address\n"
    printf "Enter desired number (0-1): "
    promptTimeout
    if [ "$PROMPT_RESULT" = "1" ]; then
        promptForPublicIp
    fi
}

#######################################
# Prompts the user for a public address.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   PUBLIC_ADDRESS
#######################################
promptForPublicIp() {
    while true; do
        printf "Service IP address: "
        promptTimeout "-t 120"
        if [ -n "$PROMPT_RESULT" ]; then
            if isValidIpv4 "$PROMPT_RESULT"; then
                PUBLIC_ADDRESS=$PROMPT_RESULT
                break
            else
                printf "%s is not a valid ip address.\n" "$PROMPT_RESULT"
            fi
        else
            break
        fi
    done
}

#######################################
# Determines if the ip is valid.
# Globals:
#   None
# Arguments:
#   IP
# Returns:
#   None
#######################################
isValidIpv4() {
    if echo "$1" | grep -qs '^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$'; then
        return 0
    else
        return 1
    fi
}

#######################################
#
# proxy.sh
#
# require prompt.sh, system.sh, replicated.sh
#
#######################################

PROXY_ADDRESS=
DID_CONFIGURE_DOCKER_PROXY=0

#######################################
# Prompts for proxy address.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   PROXY_ADDRESS
#######################################
promptForProxy() {
    printf "Does this machine require a proxy to access the Internet? "
    if ! confirmN; then
        return
    fi

    printf "Enter desired HTTP proxy address: "
    prompt
    if [ -n "$PROMPT_RESULT" ]; then
        if [ "${PROMPT_RESULT:0:7}" != "http://" ] && [ "${PROMPT_RESULT:0:8}" != "https://" ]; then
            echo >&2 "Proxy address must have prefix \"http(s)://\""
            exit 1
        fi
        PROXY_ADDRESS="$PROMPT_RESULT"
        printf "The installer will use the proxy at '%s'\n" "$PROXY_ADDRESS"
    fi
}

#######################################
# Discovers proxy address from environment.
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   PROXY_ADDRESS
#######################################
discoverProxy() {
    readReplicatedConf "HttpProxy"
    if [ -n "$REPLICATED_CONF_VALUE" ]; then
        PROXY_ADDRESS="$REPLICATED_CONF_VALUE"
        printf "The installer will use the proxy at '%s' (imported from /etc/replicated.conf 'HttpProxy')\n" "$PROXY_ADDRESS"
        return
    fi

    if [ -n "$HTTP_PROXY" ]; then
        PROXY_ADDRESS="$HTTP_PROXY"
        printf "The installer will use the proxy at '%s' (imported from env var 'HTTP_PROXY')\n" "$PROXY_ADDRESS"
        return
    elif [ -n "$http_proxy" ]; then
        PROXY_ADDRESS="$http_proxy"
        printf "The installer will use the proxy at '%s' (imported from env var 'http_proxy')\n" "$PROXY_ADDRESS"
        return
    elif [ -n "$HTTPS_PROXY" ]; then
        PROXY_ADDRESS="$HTTPS_PROXY"
        printf "The installer will use the proxy at '%s' (imported from env var 'HTTPS_PROXY')\n" "$PROXY_ADDRESS"
        return
    elif [ -n "$https_proxy" ]; then
        PROXY_ADDRESS="$https_proxy"
        printf "The installer will use the proxy at '%s' (imported from env var 'https_proxy')\n" "$PROXY_ADDRESS"
        return
    fi
}

#######################################
# Requires that docker is set up with an http proxy.
# Globals:
#   DID_INSTALL_DOCKER
# Arguments:
#   None
# Returns:
#   None
#######################################
requireDockerProxy() {
    if docker info 2>/dev/null | grep -q "Http Proxy:"; then
        return
    fi

    _allow=n
    if [ "$DID_INSTALL_DOCKER" = "1" ]; then
        _allow=y
    else
        printf "It does not look like Docker is set up with http proxy enabled.\n"
        printf "This script will automatically configure it now.\n"
        printf "Do you want to allow this? "
        if confirmY; then
            _allow=y
        fi
    fi
    if [ "$_allow" = "y" ]; then
        configureDockerProxy
    else
        printf "Do you want to proceed anyway? "
        if ! confirmN; then
            echo >&2 "Please manually configure your Docker daemon with environment HTTP_PROXY."
            exit 1
        fi
    fi
}

#######################################
# Configures docker to run with an http proxy.
# Globals:
#   INIT_SYSTEM
# Arguments:
#   None
# Returns:
#   RESTART_DOCKER
#######################################
configureDockerProxy() {
    case "$INIT_SYSTEM" in
        systemd)
            if [ ! -e /etc/systemd/system/docker.service.d/http-proxy.conf ]; then
                mkdir -p /etc/systemd/system/docker.service.d
                cat > /etc/systemd/system/docker.service.d/http-proxy.conf <<-EOF
# File created by replicated install script
[Service]
Environment="HTTP_PROXY=$PROXY_ADDRESS"
EOF
                RESTART_DOCKER=1
            fi
            ;;
        upstart|sysvinit)
            _docker_conf_file=
            if [ -e /etc/sysconfig/docker ]; then
                _docker_conf_file=/etc/sysconfig/docker
            elif [ -e /etc/default/docker ]; then
                _docker_conf_file=/etc/default/docker
            else
                _docker_conf_file=/etc/default/docker
                touch $_docker_conf_file
            fi
            if ! grep -q "^export http_proxy" $_docker_conf_file; then
                cat >> $_docker_conf_file <<-EOF

# Generated by replicated install script
export http_proxy="$PROXY_ADDRESS"
EOF
                RESTART_DOCKER=1
            fi
            ;;
        *)
            return 0
            ;;
    esac
    DID_CONFIGURE_DOCKER_PROXY=1
}

#######################################
# Check that the docker proxy configuration was successful.
# Globals:
#   DID_CONFIGURE_DOCKER_PROXY
# Arguments:
#   None
# Returns:
#   None
#######################################
checkDockerProxyConfig() {
    if [ "$DID_CONFIGURE_DOCKER_PROXY" != "1" ]; then
        return
    fi
    if docker info 2>/dev/null | grep -q "Http Proxy:"; then
        return
    fi

    echo -e "${RED}Docker proxy configuration failed.${NC}"
    printf "Do you want to proceed anyway? "
    if ! confirmN; then
        echo >&2 "Please manually configure your Docker daemon with environment HTTP_PROXY."
        exit 1
    fi
}

#######################################
# Exports proxy configuration.
# Globals:
#   PROXY_ADDRESS
# Arguments:
#   None
# Returns:
#   None
#######################################
exportProxy() {
    if [ -z "$PROXY_ADDRESS" ]; then
        return
    fi
    if [ -z "$http_proxy" ]; then
       export http_proxy=$PROXY_ADDRESS
    fi
    if [ -z "$https_proxy" ]; then
       export https_proxy=$PROXY_ADDRESS
    fi
    if [ -z "$HTTP_PROXY" ]; then
       export HTTP_PROXY=$PROXY_ADDRESS
    fi
    if [ -z "$HTTPS_PROXY" ]; then
       export HTTPS_PROXY=$PROXY_ADDRESS
    fi
}

#######################################
#
# airgap.sh
#
#######################################

#######################################
# Loads replicated main images into docker
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
airgapLoadReplicatedImages() {
    docker load < replicated.tar
    docker load < replicated-ui.tar
}

#######################################
# Loads replicated operator image into docker
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
airgapLoadOperatorImage() {
    docker load < replicated-operator.tar
}

#######################################
# Loads replicated support images into docker
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#######################################
airgapLoadSupportImages() {
    docker load < cmd.tar
    docker load < statsd-graphite.tar
    docker load < premkit.tar
    docker load < debian.tar
}

#######################################
#
# selinux.sh
#
# require common.sh docker-version.sh
#
#######################################

#######################################
# Check if SELinux is enabled
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Non-zero exit status unless SELinux is enabled
#######################################
selinux_enabled() {
    if commandExists "selinuxenabled"; then
        selinuxenabled
        return
    elif commandExists "sestatus"; then
        ENABLED=$(sestatus | grep 'SELinux status' | awk '{ print $3 }')
        echo "$ENABLED" | grep --quiet --ignore-case enabled
        return
    fi

    return 1
}

#######################################
# Check if SELinux is enforced
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   Non-zero exit status unelss SELinux is enforced
#######################################
selinux_enforced() {
    if commandExists "getenforce"; then
        ENFORCED=$(getenforce)
        echo $(getenforce) | grep --quiet --ignore-case enforcing
        return
    elif commandExists "sestatus"; then
        ENFORCED=$(sestatus | grep 'SELinux mode' | awk '{ print $3 }')
        echo "$ENFORCED" | grep --quiet --ignore-case enforcing
        return
    fi

    return 1
}

SELINUX_REPLICATED_DOMAIN_LABEL=
get_selinux_replicated_domain_label() {
    getDockerVersion

    compareDockerVersions "$DOCKER_VERSION" "1.11.0"
    if [ "$COMPARE_DOCKER_VERSIONS_RESULT" -eq "-1" ]; then
        SELINUX_REPLICATED_DOMAIN_LABEL="label:type:$SELINUX_REPLICATED_DOMAIN"
    else
        SELINUX_REPLICATED_DOMAIN_LABEL="label=type:$SELINUX_REPLICATED_DOMAIN"
    fi
}

#######################################
# Prints a warning if selinux is enabled and enforcing
# Globals:
#   None
# Arguments:
#   Mode - either permissive or enforcing
# Returns:
#   None
#######################################
function warn_if_selinux() {
    if selinux_enabled ; then
        if selinux_enforced ; then
            printf "${YELLOW}SELinux is enforcing. Running docker with the \"--selinux-enabled\" flag may cause some features to become unavailable.${NC}\n\n"
        else
            printf "${YELLOW}SELinux is enabled. Switching to enforcing mode and running docker with the \"--selinux-enabled\" flag may cause some features to become unavailable.${NC}\n\n"
        fi
    fi
}

read_replicated_opts() {
    REPLICATED_OPTS_VALUE="$(echo "$REPLICATED_OPTS" | grep -o "$1=[^ ]*" | cut -d'=' -f2)"
}

ask_for_registry_name_ipv6() {
  line=
  while [[ "$line" == "" ]]; do
    printf "Enter a hostname that resolves to $PRIVATE_ADDRESS: "
    prompt
    line=$PROMPT_RESULT
  done

  # check if it's resolvable.  it might not be ping-able.
  if ping6 -c 1 $line 2>&1 | grep -q "unknown host"; then
      echo -e >&2 "${RED}${line} cannot be resolved${NC}"
      exit 1
  fi
  REGISTRY_ADVERTISE_ADDRESS="$line"
  printf "Replicated will use \"%s\" to communicate with this server.\n" "${REGISTRY_ADVERTISE_ADDRESS}"
}

discoverPrivateIp() {
    if [ -n "$PRIVATE_ADDRESS" ]; then
        if [ "$NO_PRIVATE_ADDRESS_PROMPT" != "1" ]; then
            printf "Validating local address supplied in parameter: '%s'\n" $PRIVATE_ADDRESS
            promptForPrivateIp
        else
            printf "The installer will use local address '%s' (from parameter)\n" $PRIVATE_ADDRESS
        fi
        return
    fi

    readReplicatedConf "LocalAddress"
    if [ -n "$REPLICATED_CONF_VALUE" ]; then
        PRIVATE_ADDRESS="$REPLICATED_CONF_VALUE"
        if [ "$NO_PRIVATE_ADDRESS_PROMPT" != "1" ]; then
            printf "Validating local address found in /etc/replicated.conf: '%s'\n" $PRIVATE_ADDRESS
            promptForPrivateIp
        else
            printf "The installer will use local address '%s' (imported from /etc/replicated.conf 'LocalAddress')\n" $PRIVATE_ADDRESS
        fi
        return
    fi

    promptForPrivateIp
}

configure_docker_ipv6() {
  case "$INIT_SYSTEM" in
      systemd)
        if ! grep -q "^ExecStart.*--ipv6" /lib/systemd/system/docker.service; then
            sed -i 's/ExecStart=\/usr\/bin\/dockerd/ExecStart=\/usr\/bin\/dockerd --ipv6/' /lib/systemd/system/docker.service
            RESTART_DOCKER=1
        fi
        ;;
      upstart|sysvinit)
        if [ -e /etc/sysconfig/docker ]; then # CentOS 6
          if ! grep -q "^other_args=.*--ipv6" /etc/sysconfig/docker; then
              sed -i 's/other_args=\"/other_args=\"--ipv6/' /etc/sysconfig/docker
              RESTART_DOCKER=1
          fi
        fi

        if [ -e /etc/default/docker ]; then # Everything NOT CentOS 6
          if ! grep -q "^DOCKER_OPTS=" /etc/default/docker; then
              echo 'DOCKER_OPTS="--ipv6"' >> /etc/default/docker
              RESTART_DOCKER=1
          fi
        fi
        ;;
      *)
        return 0
        ;;
  esac
}

DAEMON_TOKEN=
get_daemon_token() {
    if [ -n "$DAEMON_TOKEN" ]; then
        return
    fi

    read_replicated_opts "DAEMON_TOKEN"
    if [ -n "$REPLICATED_OPTS_VALUE" ]; then
        DAEMON_TOKEN="$REPLICATED_OPTS_VALUE"
        return
    fi

    readReplicatedConf "DaemonToken"
    if [ -n "$REPLICATED_CONF_VALUE" ]; then
        DAEMON_TOKEN="$REPLICATED_CONF_VALUE"
        return
    fi

    getGuid
    DAEMON_TOKEN="$GUID_RESULT"
}

SELINUX_REPLICATED_DOMAIN=
CUSTOM_SELINUX_REPLICATED_DOMAIN=0
get_selinux_replicated_domain() {
    # may have been set by command line argument
    if [ -n "$SELINUX_REPLICATED_DOMAIN" ]; then
        CUSTOM_SELINUX_REPLICATED_DOMAIN=1
        return
    fi

    # if previously set to a custom domain it will be in REPLICATED_OPTS
    read_replicated_opts "SELINUX_REPLICATED_DOMAIN"
    if [ -n "$REPLICATED_OPTS_VALUE" ]; then
        SELINUX_REPLICATED_DOMAIN="$REPLICATED_OPTS_VALUE"
        CUSTOM_SELINUX_REPLICATED_DOMAIN=1
        return
    fi

    # default if unset
    SELINUX_REPLICATED_DOMAIN=spc_t
}

remove_docker_containers() {
    # try twice because of aufs error "Unable to remove filesystem"
    if docker inspect replicated &>/dev/null; then
        set +e
        docker rm -f replicated
        _status=$?
        set -e
        if [ "$_status" -ne "0" ]; then
            if docker inspect replicated &>/dev/null; then
                printf "Failed to remove replicated container, retrying\n"
                sleep 1
                docker rm -f replicated
            fi
        fi
    fi
    if docker inspect replicated-ui &>/dev/null; then
        set +e
        docker rm -f replicated-ui
        _status=$?
        set -e
        if [ "$_status" -ne "0" ]; then
            if docker inspect replicated-ui &>/dev/null; then
                printf "Failed to remove replicated-ui container, retrying\n"
                sleep 1
                docker rm -f replicated-ui
            fi
        fi
    fi
}

pull_docker_images() {
    docker pull "quay.io/replicated/replicated:stable-2.12.1"
    docker pull "quay.io/replicated/replicated-ui:stable-2.12.1"
}

tag_docker_images() {
    printf "Tagging replicated and replicated-ui images\n"
    # older docker versions require -f flag to move a tag from one image to another
    docker tag "quay.io/replicated/replicated:stable-2.12.1" "quay.io/replicated/replicated:current" 2>/dev/null \
        || docker tag -f "quay.io/replicated/replicated:stable-2.12.1" "quay.io/replicated/replicated:current"
    docker tag "quay.io/replicated/replicated-ui:stable-2.12.1" "quay.io/replicated/replicated-ui:current" 2>/dev/null \
        || docker tag -f "quay.io/replicated/replicated-ui:stable-2.12.1" "quay.io/replicated/replicated-ui:current"
}

find_hostname() {
    set +e
    SYS_HOSTNAME=`hostname -f`
    if [ "$?" -ne "0" ]; then
        SYS_HOSTNAME=`hostname`
        if [ "$?" -ne "0" ]; then
            SYS_HOSTNAME=""
        fi
    fi
    set -e
}

REPLICATED_OPTS=
build_replicated_opts() {
    # See https://github.com/golang/go/blob/23173fc025f769aaa9e19f10aa0f69c851ca2f3b/src/crypto/x509/root_linux.go
    # CentOS 6/7, RHEL 7
    # Fedora/RHEL 6 (this is a link on Centos 6/7)
    # OpenSUSE
    # OpenELEC
    # Debian/Ubuntu/Gentoo etc. This is where OpenSSL will look. It's moved to the bottom because this exists as a link on some other platforms
    set \
        "/etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem" \
        "/etc/pki/tls/certs/ca-bundle.crt" \
        "/etc/ssl/ca-bundle.pem" \
        "/etc/pki/tls/cacert.pem" \
        "/etc/ssl/certs/ca-certificates.crt"

    for cert_file do
        if [ -f "$cert_file" ]; then
            REPLICATED_TRUSTED_CERT_MOUNT="-v ${cert_file}:/etc/ssl/certs/ca-certificates.crt"
            break
        fi
    done

    if [ -n "$REPLICATED_OPTS" ]; then
        REPLICATED_OPTS=$(echo "$REPLICATED_OPTS" | sed -e 's/-e[[:blank:]]*HTTP_PROXY=[^[:blank:]]*//')
        if [ -n "$PROXY_ADDRESS" ]; then
            REPLICATED_OPTS="$REPLICATED_OPTS -e HTTP_PROXY=$PROXY_ADDRESS"
        fi
        REPLICATED_OPTS=$(echo "$REPLICATED_OPTS" | sed -e 's/-e[[:blank:]]*REGISTRY_ADVERTISE_ADDRESS=[^[:blank:]]*//')
        if [ -n "$REGISTRY_ADVERTISE_ADDRESS" ]; then
            REPLICATED_OPTS="$REPLICATED_OPTS -e REGISTRY_ADVERTISE_ADDRESS=$REGISTRY_ADVERTISE_ADDRESS"
        fi
        return
    fi


    REPLICATED_OPTS=""
    if [ -n "$PROXY_ADDRESS" ]; then
        REPLICATED_OPTS="$REPLICATED_OPTS -e HTTP_PROXY=$PROXY_ADDRESS"
    fi
    if [ -n "$REGISTRY_ADVERTISE_ADDRESS" ]; then
        REPLICATED_OPTS="$REPLICATED_OPTS -e REGISTRY_ADVERTISE_ADDRESS=$REGISTRY_ADVERTISE_ADDRESS"
    fi
    if [ "$SKIP_OPERATOR_INSTALL" != "1" ]; then
        REPLICATED_OPTS="$REPLICATED_OPTS -e DAEMON_TOKEN=$DAEMON_TOKEN"
    fi
    if [ -n "$LOG_LEVEL" ]; then
        REPLICATED_OPTS="$REPLICATED_OPTS -e LOG_LEVEL=$LOG_LEVEL"
    else
        REPLICATED_OPTS="$REPLICATED_OPTS -e LOG_LEVEL=info"
    fi
    if [ "$AIRGAP" = "1" ]; then
        REPLICATED_OPTS=$REPLICATED_OPTS" -e AIRGAP=true"
    fi
    if [ -n "$RELEASE_SEQUENCE" ]; then
        REPLICATED_OPTS="$REPLICATED_OPTS -e RELEASE_SEQUENCE=$RELEASE_SEQUENCE"
    fi
    if [ "$CUSTOM_SELINUX_REPLICATED_DOMAIN" = "1" ]; then
        REPLICATED_OPTS="$REPLICATED_OPTS -e SELINUX_REPLICATED_DOMAIN=$SELINUX_REPLICATED_DOMAIN"
    fi

    find_hostname
    REPLICATED_OPTS="$REPLICATED_OPTS -e NODENAME=$SYS_HOSTNAME"

    REPLICATED_UI_OPTS=""
    if [ -n "$LOG_LEVEL" ]; then
        REPLICATED_UI_OPTS="$REPLICATED_UI_OPTS -e LOG_LEVEL=$LOG_LEVEL"
    fi
}

write_replicated_configuration() {
    cat > $CONFDIR/replicated <<-EOF
RELEASE_CHANNEL=stable
PRIVATE_ADDRESS=$PRIVATE_ADDRESS
SKIP_OPERATOR_INSTALL=$SKIP_OPERATOR_INSTALL
REPLICATED_OPTS="$REPLICATED_OPTS"
REPLICATED_UI_OPTS="$REPLICATED_UI_OPTS"
EOF
}

write_systemd_services() {
    cat > /etc/systemd/system/replicated.service <<-EOF
[Unit]
Description=Replicated Service
After=docker.service
Requires=docker.service

[Service]
PermissionsStartOnly=true
TimeoutStartSec=0
KillMode=none
EnvironmentFile=${CONFDIR}/replicated
User=${REPLICATED_USER_ID}
Group=${DOCKER_GROUP_ID}
ExecStartPre=-/usr/bin/docker rm -f replicated
ExecStartPre=/bin/mkdir -p /var/run/replicated /var/lib/replicated /premkit/data /var/lib/replicated/statsd
ExecStartPre=/bin/chown -R ${REPLICATED_USER_ID}:${DOCKER_GROUP_ID} /var/run/replicated /var/lib/replicated /premkit/data
ExecStartPre=-/bin/chmod -R 755 /var/lib/replicated/tmp
ExecStart=/usr/bin/docker run --name=replicated \\
    -p 9874-9879:9874-9879/tcp \\
    -u ${REPLICATED_USER_ID}:${DOCKER_GROUP_ID} \\
    -v /var/lib/replicated:/var/lib/replicated \\
    -v /var/run/docker.sock:/host/var/run/docker.sock \\
    -v /proc:/host/proc:ro \\
    -v /etc:/host/etc:ro \\
    -v /etc/os-release:/host/etc/os-release:ro \\
    ${REPLICATED_TRUSTED_CERT_MOUNT} \\
    -v /var/run/replicated:/var/run/replicated \\
    --security-opt ${SELINUX_REPLICATED_DOMAIN_LABEL} \\
    -e LOCAL_ADDRESS=\${PRIVATE_ADDRESS} \\
    -e RELEASE_CHANNEL=\${RELEASE_CHANNEL} \\
    \$REPLICATED_OPTS \\
    quay.io/replicated/replicated:current
ExecStop=/usr/bin/docker stop replicated
Restart=on-failure
RestartSec=7

[Install]
WantedBy=multi-user.target
EOF

    cat > /etc/systemd/system/replicated-ui.service <<-EOF
[Unit]
Description=Replicated Service
After=docker.service
Requires=docker.service

[Service]
PermissionsStartOnly=true
TimeoutStartSec=0
KillMode=none
EnvironmentFile=${CONFDIR}/replicated
User=${REPLICATED_USER_ID}
Group=${DOCKER_GROUP_ID}
ExecStartPre=-/usr/bin/docker rm -f replicated-ui
ExecStartPre=/bin/mkdir -p /var/run/replicated
ExecStartPre=/bin/chown -R ${REPLICATED_USER_ID}:${DOCKER_GROUP_ID} /var/run/replicated
ExecStart=/usr/bin/docker run --name=replicated-ui \\
    -p ${UI_BIND_PORT}:8800/tcp \\
    -u ${REPLICATED_USER_ID}:${DOCKER_GROUP_ID} \\
    -v /var/run/replicated:/var/run/replicated \\
    --security-opt ${SELINUX_REPLICATED_DOMAIN_LABEL} \\
    \$REPLICATED_UI_OPTS \\
    quay.io/replicated/replicated-ui:current
ExecStop=/usr/bin/docker stop replicated-ui
Restart=on-failure
RestartSec=7

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
}

write_upstart_services() {
    cat > /etc/init/replicated.conf <<-EOF
description "Replicated Service"
author "Replicated.com"
start on filesystem and started docker and runlevel [2345]
start on stopped rc RUNLEVEL=[2345]
stop on runlevel [!2345]
stop on started rc RUNLEVEL=[!2345]
respawn
respawn limit 5 10
normal exit 0
pre-start script
    /bin/mkdir -p /var/run/replicated /var/lib/replicated /premkit/data /var/lib/replicated/statsd
    /bin/chown -R ${REPLICATED_USER_ID}:${DOCKER_GROUP_ID} /var/run/replicated /var/lib/replicated /premkit/data
    /bin/chmod -R 755 /var/lib/replicated/tmp 2>/dev/null || true
    /usr/bin/docker rm -f replicated 2>/dev/null || true
end script
pre-stop script
    /usr/bin/docker stop replicated
end script
script
    . ${CONFDIR}/replicated
    exec su -s /bin/sh -c 'exec "\$0" "\$@"' ${REPLICATED_USERNAME} -- /usr/bin/docker run --name=replicated \\
        -p 9874-9879:9874-9879/tcp \\
        -u ${REPLICATED_USER_ID}:${DOCKER_GROUP_ID} \\
        -v /var/lib/replicated:/var/lib/replicated \\
        -v /var/run/docker.sock:/host/var/run/docker.sock \\
        -v /proc:/host/proc:ro \\
        -v /etc:/host/etc:ro \\
        -v /etc/os-release:/host/etc/os-release:ro \\
        ${REPLICATED_TRUSTED_CERT_MOUNT} \\
        -v /var/run/replicated:/var/run/replicated \\
        --security-opt ${SELINUX_REPLICATED_DOMAIN_LABEL} \\
        -e LOCAL_ADDRESS=\${PRIVATE_ADDRESS} \\
        -e RELEASE_CHANNEL=\${RELEASE_CHANNEL} \\
        \$REPLICATED_OPTS \\
        quay.io/replicated/replicated:current
end script
EOF

    cat > /etc/init/replicated-ui.conf <<-EOF
description "Replicated UI Service"
author "Replicated.com"
start on filesystem and started docker and runlevel [2345]
start on stopped rc RUNLEVEL=[2345]
stop on runlevel [!2345]
stop on started rc RUNLEVEL=[!2345]
respawn
respawn limit 5 10
normal exit 0
pre-start script
    /bin/mkdir -p /var/run/replicated
    /bin/chown -R ${REPLICATED_USER_ID}:${DOCKER_GROUP_ID} /var/run/replicated
    /usr/bin/docker rm -f replicated-ui 2>/dev/null || true
end script
pre-stop script
    /usr/bin/docker stop replicated-ui
end script
script
    . ${CONFDIR}/replicated
    exec su -s /bin/sh -c 'exec "\$0" "\$@"' ${REPLICATED_USERNAME} -- /usr/bin/docker run --name=replicated-ui \\
        -p ${UI_BIND_PORT}:8800/tcp \\
        -u ${REPLICATED_USER_ID}:${DOCKER_GROUP_ID} \\
        -v /var/run/replicated:/var/run/replicated \\
        --security-opt ${SELINUX_REPLICATED_DOMAIN_LABEL} \\
        \$REPLICATED_UI_OPTS \\
        quay.io/replicated/replicated-ui:current
end script
EOF
}

write_sysvinit_services() {
    cat > /etc/init.d/replicated <<-EOF
#!/bin/bash
set -e

### BEGIN INIT INFO
# Provides:          replicated
# Required-Start:    docker
# Required-Stop:     docker
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Replicated
# Description:       Replicated Service
### END INIT INFO

REPLICATED=replicated
DOCKER=/usr/bin/docker
DEFAULTS=${CONFDIR}/replicated

[ -r "\${DEFAULTS}" ] && . "\${DEFAULTS}"
[ -r "/lib/lsb/init-functions" ] && . "/lib/lsb/init-functions"
[ -r "/etc/rc.d/init.d/functions" ] && . "/etc/rc.d/init.d/functions"

if [ ! -x \${DOCKER} ]; then
    echo -n >&2 "\${DOCKER} not present or not executable"
    exit 1
fi

run_container() {
    /bin/mkdir -p /var/run/replicated /var/lib/replicated /premkit/data /var/lib/replicated/statsd
    /bin/chown -R ${REPLICATED_USER_ID}:${DOCKER_GROUP_ID} /var/run/replicated /var/lib/replicated /premkit/data
    /bin/chmod -R 755 /var/lib/replicated/tmp 2>/dev/null || true
    /usr/bin/docker rm -f replicated 2>/dev/null || true
    exec su -s /bin/sh -c 'exec "\$0" "\$@"' ${REPLICATED_USERNAME} -- \${DOCKER} run -d --name=\${REPLICATED} \\
        -p 9874-9879:9874-9879/tcp \\
        -u ${REPLICATED_USER_ID}:${DOCKER_GROUP_ID} \\
        -v /var/lib/replicated:/var/lib/replicated \\
        -v /var/run/docker.sock:/host/var/run/docker.sock \\
        -v /proc:/host/proc:ro \\
        -v /etc:/host/etc:ro \\
        -v /etc/os-release:/host/etc/os-release:ro \\
        ${REPLICATED_TRUSTED_CERT_MOUNT} \\
        -v /var/run/replicated:/var/run/replicated \\
        --security-opt ${SELINUX_REPLICATED_DOMAIN_LABEL} \\
        -e LOCAL_ADDRESS=\${PRIVATE_ADDRESS} \\
        -e RELEASE_CHANNEL=\${RELEASE_CHANNEL} \\
        \$REPLICATED_OPTS \\
        quay.io/replicated/replicated:current
}

stop_container() {
    \${DOCKER} stop \${REPLICATED}
}

remove_container() {
    \${DOCKER} rm -f \${REPLICATED}
}

_status() {
	if type status_of_proc | grep -i function > /dev/null; then
	    status_of_proc "\${REPLICATED}" && exit 0 || exit \$?
	elif type status | grep -i function > /dev/null; then
		status "\${REPLICATED}" && exit 0 || exit \$?
	else
		exit 1
	fi
}

case "\$1" in
    start)
        echo -n "Starting \${REPLICATED} service: "
        remove_container 2>/dev/null || true
        run_container
        ;;
    stop)
        echo -n "Shutting down \${REPLICATED} service: "
        stop_container
        ;;
    status)
        _status
        ;;
    restart|reload)
        pid=`pidofproc "\${REPLICATED}" 2>/dev/null`
        [ -n "\$pid" ] && ps -p \$pid > /dev/null 2>&1 \\
            && \$0 stop
        \$0 start
        ;;
    *)
        echo "Usage: \${REPLICATED} {start|stop|status|reload|restart"
        exit 1
        ;;
esac
EOF
    chmod +x /etc/init.d/replicated

    cat > /etc/init.d/replicated-ui <<-EOF
#!/bin/bash
set -e

### BEGIN INIT INFO
# Provides:          replicated-ui
# Required-Start:    docker
# Required-Stop:     docker
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Replicated UI
# Description:       Replicated UI Service
### END INIT INFO

REPLICATED_UI=replicated-ui
DOCKER=/usr/bin/docker
DEFAULTS=${CONFDIR}/replicated

[ -r "\${DEFAULTS}" ] && . "\${DEFAULTS}"
[ -r "/lib/lsb/init-functions" ] && . "/lib/lsb/init-functions"
[ -r "/etc/rc.d/init.d/functions" ] && . "/etc/rc.d/init.d/functions"

if [ ! -x \${DOCKER} ]; then
    echo -n >&2 "\${DOCKER} not present or not executable"
    exit 1
fi

run_container() {
    exec su -s /bin/sh -c 'exec "\$0" "\$@"' ${REPLICATED_USERNAME} -- \${DOCKER} run -d --name=\${REPLICATED_UI} \\
        -p ${UI_BIND_PORT}:8800/tcp \\
        -u ${REPLICATED_USER_ID}:${DOCKER_GROUP_ID} \\
        -v /var/run/replicated:/var/run/replicated \\
        --security-opt ${SELINUX_REPLICATED_DOMAIN_LABEL} \\
        \$REPLICATED_UI_OPTS \\
        quay.io/replicated/replicated-ui:current
}

stop_container() {
    \${DOCKER} stop \${REPLICATED_UI}
}

remove_container() {
    \${DOCKER} rm -f \${REPLICATED_UI}
}

_status() {
	if type status_of_proc | grep -i function > /dev/null; then
	    status_of_proc "\${REPLICATED_UI}" && exit 0 || exit \$?
	elif type status | grep -i function > /dev/null; then
		status "\${REPLICATED_UI}" && exit 0 || exit \$?
	else
		exit 1
	fi
}

case "\$1" in
    start)
        echo -n "Starting \${REPLICATED_UI} service: "
        remove_container 2>/dev/null || true
        run_container
        ;;
    stop)
        echo -n "Shutting down \${REPLICATED_UI} service: "
        stop_container
        ;;
    status)
        _status
        ;;
    restart|reload)
        pid=`pidofproc "\${REPLICATED_UI}" 2>/dev/null`
        [ -n "\$pid" ] && ps -p \$pid > /dev/null 2>&1 \\
            && \$0 stop
        \$0 start
        ;;
    *)
        echo "Usage: \${REPLICATED_UI} {start|stop|status|reload|restart"
        exit 1
        ;;
esac
EOF
    chmod +x /etc/init.d/replicated-ui
}

stop_systemd_services() {
    if systemctl status replicated &>/dev/null; then
        systemctl stop replicated
    fi
    if systemctl status replicated-ui &>/dev/null; then
        systemctl stop replicated-ui
    fi
}

start_systemd_services() {
    systemctl enable replicated
    systemctl enable replicated-ui
    systemctl start replicated
    systemctl start replicated-ui
}

stop_upstart_services() {
    if status replicated &>/dev/null && ! status replicated 2>/dev/null | grep -q "stop"; then
        stop replicated
    fi
    if status replicated-ui &>/dev/null && ! status replicated-ui 2>/dev/null | grep -q "stop"; then
        stop replicated-ui
    fi
}

start_upstart_services() {
    start replicated
    start replicated-ui
}

stop_sysvinit_services() {
    if service replicated status &>/dev/null; then
        service replicated stop
    fi
    if service replicated-ui status &>/dev/null; then
        service replicated-ui stop
    fi
}

start_sysvinit_services() {
    # TODO: what about chkconfig
    update-rc.d replicated stop 20 0 1 6 . start 20 2 3 4 5 .
    update-rc.d replicated-ui stop 20 0 1 6 . start 20 2 3 4 5 .
    update-rc.d replicated enable
    update-rc.d replicated-ui enable
    service replicated start
    service replicated-ui start
}

install_operator() {
    prefix=""
    if [ "$AIRGAP" != "1" ]; then
        getUrlCmd
        echo -e "${GREEN}Installing local operator with command:"
        echo -e "${URLGET_CMD} https://get.replicated.com${prefix}/operator?replicated_operator_tag=2.12.1${NC}"
        ${URLGET_CMD} "https://get.replicated.com${prefix}/operator?replicated_operator_tag=2.12.1" > /tmp/operator_install.sh
    fi
    opts="no-docker daemon-endpoint=[$PRIVATE_ADDRESS]:9879 daemon-token=$DAEMON_TOKEN private-address=$PRIVATE_ADDRESS tags=$OPERATOR_TAGS"
    if [ -n "$PUBLIC_ADDRESS" ]; then
        opts=$opts" public-address=$PUBLIC_ADDRESS"
    fi
    if [ -n "$PROXY_ADDRESS" ]; then
        opts=$opts" http-proxy=$PROXY_ADDRESS"
    else
        opts=$opts" no-proxy"
    fi
    if [ -z "$READ_TIMEOUT" ]; then
        opts=$opts" no-auto"
    fi
    if [ "$AIRGAP" = "1" ]; then
        opts=$opts" airgap"
    fi
    if [ "$SKIP_DOCKER_PULL" = "1" ]; then
        opts=$opts" skip-pull"
    fi
    if [ -n "$LOG_LEVEL" ]; then
        opts=$opts" log-level=$LOG_LEVEL"
    fi
    if [ "$CUSTOM_SELINUX_REPLICATED_DOMAIN" = "1" ]; then
        opts=$opts" selinux-replicated-domain=$SELINUX_REPLICATED_DOMAIN"
    fi
    # When this script is piped into bash as stdin, apt-get will eat the remaining parts of this script,
    # preventing it from being executed.  So using /dev/null here to change stdin for the docker script.
    if [ "$AIRGAP" = "1" ]; then
        bash ./operator_install.sh $opts < /dev/null
    else
        bash /tmp/operator_install.sh $opts < /dev/null
    fi
}

outro() {
    warn_if_selinux
    if [ -z "$PUBLIC_ADDRESS" ]; then
        PUBLIC_ADDRESS="<this_server_address>"
    fi
    printf "To continue the installation, visit the following URL in your browser:\n\n  https://%s:$UI_BIND_PORT\n" "$PUBLIC_ADDRESS"
    if ! commandExists "replicated"; then
        printf "\nTo create an alias for the replicated cli command run the following in your current shell or log out and log back in:\n\n  source /etc/replicated.alias\n"
    fi
    printf "\n"
}


################################################################################
# Execution starts here
################################################################################

if replicated12Installed; then
    echo >&2 "Existing 1.2 install detected; please back up and run migration script before installing"
    echo >&2 "Instructions at https://www.replicated.com/docs/distributing-an-application/installing/#migrating-from-replicated-v1"
    exit 1
fi

require64Bit
requireRootUser
detectLsbDist
detectInitSystem

mkdir -p /var/lib/replicated/branding
echo "$CHANNEL_CSS" | base64 --decode > /var/lib/replicated/branding/channel.css

CONFDIR="/etc/default"
if [ "$INIT_SYSTEM" = "systemd" ] && [ -d "/etc/sysconfig" ]; then
    CONFDIR="/etc/sysconfig"
fi

# read existing replicated opts values
if [ -f $CONFDIR/replicated ]; then
    # shellcheck source=replicated-default
    . $CONFDIR/replicated
fi
if [ -f $CONFDIR/replicated-operator ]; then
    # support for the old installation script that used REPLICATED_OPTS for
    # operator
    tmp_replicated_opts="$REPLICATED_OPTS"
    # shellcheck source=replicated-operator-default
    . $CONFDIR/replicated-operator
    REPLICATED_OPTS="$tmp_replicated_opts"
fi

# override these values with command line flags
while [ "$1" != "" ]; do
    _param="$(echo "$1" | cut -d= -f1)"
    _value="$(echo "$1" | grep '=' | cut -d= -f2-)"
    case $_param in
        http-proxy|http_proxy)
            PROXY_ADDRESS="$_value"
            ;;
        local-address|local_address|private-address|private_address)
            PRIVATE_ADDRESS="$_value"
            NO_PRIVATE_ADDRESS_PROMPT="1"
            ;;
        public-address|public_address)
            PUBLIC_ADDRESS="$_value"
            ;;
        no-operator|no_operator)
            SKIP_OPERATOR_INSTALL=1
            ;;
        is-migration|is_migration)
            IS_MIGRATION=1
            ;;
        no-docker|no_docker)
            SKIP_DOCKER_INSTALL=1
            ;;
        install-docker-only|install_docker_only)
            ONLY_INSTALL_DOCKER=1
            ;;
        no-proxy|no_proxy)
            NO_PROXY=1
            ;;
        airgap)
            # airgap implies "no proxy" and "skip docker"
            AIRGAP=1
            SKIP_DOCKER_INSTALL=1
            NO_PROXY=1
            ;;
        no-auto|no_auto)
            READ_TIMEOUT=
            ;;
        daemon-token|daemon_token)
            DAEMON_TOKEN="$_value"
            ;;
        tags)
            OPERATOR_TAGS="$_value"
            ;;
        docker-version|docker_version)
            PINNED_DOCKER_VERSION="$_value"
            ;;
        ui-bind-port|ui_bind_port)
            UI_BIND_PORT="$_value"
            ;;
        registry-advertise-address|registry_advertise_address)
            REGISTRY_ADVERTISE_ADDRESS="$_value"
            ;;
        release-sequence|release_sequence)
            RELEASE_SEQUENCE="$_value"
            ;;
        skip-pull|skip_pull)
            SKIP_DOCKER_PULL=1
            ;;
        bypass-storagedriver-warnings|bypass_storagedriver_warnings)
            BYPASS_STORAGEDRIVER_WARNINGS=1
            ;;
        log-level|log_level)
            LOG_LEVEL="$_value"
            ;;
        selinux-replicated-domain|selinux_replicated_domain)
            SELINUX_REPLICATED_DOMAIN="$_value"
            ;;
        *)
            echo >&2 "Error: unknown parameter \"$_param\""
            exit 1
            ;;
    esac
    shift
done

if [ "$ONLY_INSTALL_DOCKER" = "1" ]; then
    # no min if only installing docker
    installDocker "$PINNED_DOCKER_VERSION" "0.0.0"

    checkDockerDriver
    checkDockerStorageDriver
    exit 0
fi

printf "Determining local address\n"
discoverPrivateIp

if [ "$AIRGAP" != "1" ]; then
    printf "Determining service address\n"
    discoverPublicIp
fi

if [ "$NO_PROXY" != "1" ]; then
    if [ -z "$PROXY_ADDRESS" ]; then
        discoverProxy
    fi

    if [ -z "$PROXY_ADDRESS" ]; then
        promptForProxy
    fi
fi

exportProxy

if [ "$SKIP_DOCKER_INSTALL" != "1" ]; then
    installDocker "$PINNED_DOCKER_VERSION" "$MIN_DOCKER_VERSION"

    checkDockerDriver
    checkDockerStorageDriver
fi

if [ -n "$PROXY_ADDRESS" ]; then
    requireDockerProxy
fi

if [ "$CONFIGURE_IPV6" = "1" ] && [ "$DID_INSTALL_DOCKER" = "1" ]; then
    configure_docker_ipv6
fi

if [ "$RESTART_DOCKER" = "1" ]; then
    restartDocker
fi

if [ -n "$PROXY_ADDRESS" ]; then
    checkDockerProxyConfig
fi


detectDockerGroupId
maybeCreateReplicatedUser

get_daemon_token

if [ "$SKIP_DOCKER_PULL" = "1" ]; then
    printf "Skip docker pull flag detected, will not pull replicated and replicated-ui containers\n"
elif [ "$AIRGAP" != "1" ]; then
    printf "Pulling replicated and replicated-ui containers\n"
    pull_docker_images
else
    printf "Loading replicated and replicated-ui images from package\n"
    airgapLoadReplicatedImages
    printf "Loading replicated debian, command, statsd-graphite, and premkit images from package\n"
    airgapLoadSupportImages
fi

tag_docker_images

printf "Stopping replicated and replicated-ui service\n"
case "$INIT_SYSTEM" in
    systemd)
        stop_systemd_services
        ;;
    upstart)
        stop_upstart_services
        ;;
    sysvinit)
        stop_sysvinit_services
        ;;
esac
remove_docker_containers

printf "Installing replicated and replicated-ui service\n"
get_selinux_replicated_domain
get_selinux_replicated_domain_label
build_replicated_opts
write_replicated_configuration
case "$INIT_SYSTEM" in
    systemd)
        write_systemd_services
        ;;
    upstart)
        write_upstart_services
        ;;
    sysvinit)
        write_sysvinit_services
        ;;
esac

printf "Starting replicated and replicated-ui service\n"
case "$INIT_SYSTEM" in
    systemd)
        start_systemd_services
        ;;
    upstart)
        start_upstart_services
        ;;
    sysvinit)
        start_sysvinit_services
        ;;
esac

printf "Installing replicated command alias\n"
installCLIFile "replicated"
installAliasFile

if [ "$SKIP_OPERATOR_INSTALL" != "1" ] && [ "$IS_MIGRATION" != "1" ]; then
    # we write this value to the opts file so if you didn't install it the first
    # time it will not install when updating
    printf "Installing local operator\n"
    install_operator
fi

outro
exit 0