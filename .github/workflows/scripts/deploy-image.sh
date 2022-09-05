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
touch $OUTPUT_PATH



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
    
    echo ""  > found_tag
    while IFS= read -r line; do
        re='^[0-9]+$'
        line=$(echo "$line" | tr -d '"' | sed 's/,*$//' | xargs)
        echo "checking tag: $line" 
        if [[ $line =~ $re ]] ; then
          echo "$line" > found_tag
          echo "using: $line"
          break;
        fi
    done <<< "$image_tags"
    
    # FOUND_TAG=$(cat found_tag)
    # if [ -z "$FOUND_TAG" ]
    # then
    #   FOUND_TAG=$IMAGE_TAG_ANCHOR
    #   echo "using fallback tag"
    # fi
    # echo "FOUND_TAG: $FOUND_TAG"
    # if ! [ -z "$VERSIONS" ]
    # then
    #   VERSIONS+=" "
    # fi

    # VERSIONS+="-p $SERVICE_NAME.image.tag=$FOUND_TAG"
done
# echo "$VERSIONS" >> $OUTPUT_PATH
# echo "VERSIONS=$VERSIONS" >> $GITHUB_ENV
