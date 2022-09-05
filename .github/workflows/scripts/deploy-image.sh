#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "script_dir: $SCRIPT_DIR"
TARGET_ENV=${TARGET_ENV:=dev}
echo "target_env: $TARGET_ENV"
OUTPUT_PATH=${OUTPUT_PATH:=versions.command}
echo "output_path: $OUTPUT_PATH"
ROOT_FOLDER=${GITHUB_WORKSPACE:=$SCRIPT_DIR/devops}
echo "root_folder: $ROOT_FOLDER"
HELM_SERVICES_FOLDER="$ROOT_FOLDER/devops/services"
echo "helm_service_folder: $HELM_SERVICES_FOLDER"
IMAGE_TAG_ANCHOR=${BRANCH_NAME:=master}
echo "image_tag_anchor: $IMAGE_TAG_ANCHOR"
mkdir ./values


for dir in /$HELM_SERVICES_FOLDER/*/
do
    echo "cleaning up $dir"
    SERVICE_NAME="$(basename $dir)"
    REPO_NAME="$SERVICE_NAME"
    echo "SERVICE_NAME: $SERVICE_NAME"
    echo "REPO_NAME: $REPO_NAME"
    tag_list="$(aws ecr describe-images --repository-name=$REPO_NAME --region us-east-1 --image-ids=imageTag=$IMAGE_TAG_ANCHOR 2> /dev/null )"
    image_tags=$(echo $tag_list | jq -r '.imageDetails[0].imageTags' 2>&1)
    echo "tag_list: $tag_list"
    echo "image_tags: $image_tags"
    if [ -z "$image_tags" ]
    then
      echo "there is no tag images for this branch name"
      tag_list="$(aws ecr describe-images --repository-name=$REPO_NAME --region us-east-1 --image-ids=imageTag=develop 2> /dev/null )"
      image_tags=$(echo $tag_list | jq -r '.imageDetails[0].imageTags' 2>&1)
      echo "tag_list: $tag_list"
      echo "image_tags: $image_tags"      
    fi

    if [[ $SERVICE_NAME != 'kafka-ui' ]]
    then
        while IFS= read -r line; do
            re='^[0-9]+$'
            line=$(echo "$line" | tr -d '"' | sed 's/,*$//' | xargs)
            echo "checking tag: $line" 
            if [[ $line =~ $re ]] ; then
            printf "
$SERVICE_NAME:
    image:
      tag: '$line'" >> ./values/services-image-tags.yaml
            echo "using: $line"
            break;
            fi
        done <<< "$image_tags"
    fi
done
pwd
ls -la
cat ./services-image-tags.yaml
# echo "$VERSIONS" >> $OUTPUT_PATH
# echo "VERSIONS=$VERSIONS" >> $GITHUB_ENV
