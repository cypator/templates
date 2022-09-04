#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "script dir: $SCRIPT_DIR "
ROOT_FOLDER=${GITHUB_WORKSPACE:=$SCRIPT_DIR/devops}
echo "root folder: $ROOT_FOLDER "
HELM_SERVICES_FOLDER="$ROOT_FOLDER/services"
echo "services folder: $HELM_SERVICES_FOLDER "
IMAGE_TAG_ANCHOR=${BRANCH_NAME:=master}
echo "image folder: $IMAGE_TAG_ANCHOR "

for dir in /$HELM_SERVICES_FOLDER/*/
do
    echo "cleaning up $dir"
    SERVICE_NAME="$(basename $dir)"
    REPO_NAME="$SERVICE_NAME"
    echo "SERVICE_NAME: $SERVICE_NAME"
    echo "REPO_NAME: $REPO_NAME"
    # cmd="$(aws ecr describe-images --repository-name=$REPO_NAME --image-ids=imageTag=$IMAGE_TAG_ANCHOR)"
    # if [ -z "$cmd" ]
    # then
    #     echo "This branch name doesn't exist in the repository - $REPO_NAME"
    #     echo "::set-output name=image_exist::false"
    #     exit 1
    # else
    #     echo "tag already exists in the repository - $REPO_NAME"
    #     echo "::set-output name=image_exist::true"
    # fi
done