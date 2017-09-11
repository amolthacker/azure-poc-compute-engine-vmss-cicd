#!/bin/bash

BASE_DIR="$(dirname $0)"
source $BASE_DIR/az-credentials.sh
source $BASE_DIR/utils.sh baker

#################################
# Functions
#################################

function usage
{
    echo -e "${GRAY}"
	echo " Usage: $0 "
	echo "   -i, --image <image_name>            : Name of the Image to be baked using Packer template : packer/template-<image_name>.json"
	echo "   -b, --with-base <yes|no>            : Re-bake base image"
	echo "   -u, --base-img-url <base_img_url>   : URL of Base Image if --with-base no"
	echo "   -h, --help                          : Help"
	echo -e "${NC}"
	exit 1
}

function bakeImage ()
{
    [[ -z $1 ]] && exitWithErr "Missing image name"

    PACKER_TEMPLATE="packer/template-$1.json"

    logInfo "Validating Packer template for baking $1 Azure VM image ..."
    packer validate ${PACKER_TEMPLATE}
    exitOnErr "Invalid Packer template"

    logInfo "Baking $1 Azure VM image ..."
    packer build ${PACKER_TEMPLATE} 2>&1 | tee "baker-$1.log"
    exitOnErr "Error baking image $1"
}

function image_url ()
{
    [[ -z $1 ]] && exitWithErr "Missing image name"

    bake_log="baker-$1.log"

    if [ -f ${bake_log} ]
    then
        url=$(tail ${bake_log} | grep "OSDiskUri:" | awk -F': ' '{print $2}')
        echo "$url"
    else
        exitWithErr "Image bake log ${bake_log} not found"
    fi
}

#################################


[[ $# -lt 4 ]] && usage

WITH_BASE="no"
BASE_IMG_URL="UNKNOWN"

while [[ $# -gt 1 ]]
do
key="$1"
case $key in
    -i|--image)
    IMG_NAME="$2"
    shift
    ;;
    -b|--with-base)
    WITH_BASE="$2"
    [[ ${WITH_BASE} != 'yes' ]] && [[ ${WITH_BASE} != 'no' ]] && usage
    shift
    ;;
     -u|--base-img-url)
    BASE_IMG_URL="$2"
    shift
    ;;
    -h|--help)
    usage
    shift
    ;;
    *)
    ;;
esac
shift # past argument or value
done

echo "WITH_BASE: ${WITH_BASE}"
echo "BASE_IMG_URL: ${BASE_IMG_URL}"


if [ ${WITH_BASE} == 'no' ] && [ ${BASE_IMG_URL} == 'UNKNOWN' ];
then
    logInfo "Must specify base image URL if not baking with base image"
    usage
fi

BASE_IMG_NAME="${IMG_NAME}-base"
BASE_DIR="$(dirname $0)"
source $BASE_DIR/az-credentials.sh

logInfo "==================================================="
logInfo "Azure Details"
logInfo "==================================================="
logInfo "Subscription Id: ${subscription_id}"
logInfo "Tenant Id      : ${tenant_id}"
logInfo "Client Id      : ${client_id}"
logInfo "Resource Group : ${resource_group}"
logInfo "Location       : ${location}"
logInfo "==================================================="

if [ ${WITH_BASE} == 'yes' ]
then
    img=${BASE_IMG_NAME}
    bakeImage $img
    BASE_IMG_URL=$(image_url $img)
fi

export base_img_url=${BASE_IMG_URL}
logInfo "Base Image URL: ${base_img_url}"

img=${IMG_NAME}
bakeImage $img
IMG_URL=$(image_url $img)
[[ $? -ne 0 ]] && echo ${IMG_URL} && exit 1

export img_url=${IMG_URL}
logInfo "Image URL: ${img_url}"

logInfo "==================================================="
