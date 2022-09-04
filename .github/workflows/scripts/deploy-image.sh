#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "script dir: $SCRIPT_DIR "
ROOT_FOLDER=${GITHUB_WORKSPACE:=$SCRIPT_DIR/helm}
echo "root folder: $ROOT_FOLDER "
HELM_SERVICES_FOLDER="$ROOT_FOLDER/services"
echo "services folder: $HELM_SERVICES_FOLDER "
IMAGE_TAG_ANCHOR=${BRANCH_NAME:=master}
echo "image folder: $IMAGE_TAG_ANCHOR "
