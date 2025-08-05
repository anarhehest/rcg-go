#!/bin/bash

set -e

SCRIPT_PATH="$(cd $(dirname "$0") >/dev/null 2>&1 && pwd)"
PROJECT_PATH="${SCRIPT_PATH}/.."

# -----------------------------------------------------------------------------
build_img() {
   _log "Build docker image [$IMAGENAME:$IMGVERS1] [$IMAGENAME:$IMGVERS2]"
   mkdir -p ${PROJECT_PATH}/build
   cp -rf ${PROJECT_PATH}/src ${PROJECT_PATH}/build
   cp -f ${PROJECT_PATH}/docker/Dockerfile.simple ${PROJECT_PATH}/build/Dockerfile
   cp -f ${PROJECT_PATH}/docker/SETTINGS ${PROJECT_PATH}/build
   pushd ${PROJECT_PATH}/build >/dev/null 2>&1
     source ./SETTINGS
     docker build --progress=plain -t "${LIBRARY}"/"${IMAGENAME}":"${IMGVERS1}" -t "${LIBRARY}"/"${IMAGENAME}":"${IMGVERS2}" .
   popd
}

# -----------------------------------------------------------------------------
_log() {
  echo -e "--- $@"
}

# -----------------------------------------------------------------------------
find_tool() {
    local PARAM_CMD="${1}"
    RES_TMP="$(which ${PARAM_CMD} 2>&1)"
    if [ "${?}" != "0" ]; then
      echo "Tools [${PARAM_CMD}] NOT FOUND (Please install first)"
      return 127
    fi
    return 0
}

# -----------------------------------------------------------------------------
docker_check_privileges() {
    docker ps 2>&1 >/dev/null
    if [ "${?}" != "0" ]; then
       _log "ERROR: Docker not runing or not accessed"
       return 127
    else
       _log "OK"
       return 0
    fi
}


# -----------------------------------------------------------------------------

_log "--- Detecting tools"
find_tool docker || FIND_RES=1
if [ "${FIND_RES}" == "1" ]; then
 _log "Please install required tools"
 exit 127
else
 _log "OK".
fi

# Check docker access
_log "--- Check Docker privileges"
docker_check_privileges
if [ "${?}" != "0" ]; then
  exit 127
fi


build_img
 