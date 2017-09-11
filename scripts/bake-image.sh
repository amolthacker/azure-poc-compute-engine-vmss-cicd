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
	echo "   -i, --image <image_name>               : Name of the Image to be baked using Packer template : packer/template-<image_name>.json"
	echo "   -b, --with-base <yes|no>               : Re-bake base image '<image_name>-base'"
	echo "   -n, --base-img-name <base_img_name>    : Name of the Managed Base Image if --with-base no"
	echo "   -h, --help                             : Help"
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

#################################


[[ $# -lt 4 ]] && usage

WITH_BASE="no"
BASE_IMG_INST="UNKNOWN"

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
    -n|--base-img-name)
    BASE_IMG_INST="$2"
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

DTF=$(datetimefmtd)
BASE_IMG_NAME="${IMG_NAME}-base"

if [ ${WITH_BASE} == 'no' ] && [ ${BASE_IMG_INST} == 'UNKNOWN' ];
then
    logErr "Must specify base image name if not baking with base image"
    usage
fi

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
    export base_img_name="${BASE_IMG_NAME}-${DTF}"
    logInfo "Base Image instance: ${base_img_name}"
    bakeImage ${BASE_IMG_NAME}
else
    export base_img_name="${BASE_IMG_INST}"
    logInfo "Base Image instance: ${base_img_name}"
fi

export app_img_name="${IMG_NAME}-${DTF}"
logInfo "App Image instance: ${app_img_name}"
bakeImage ${IMG_NAME}

logInfo "==================================================="