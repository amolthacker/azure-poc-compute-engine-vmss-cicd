#!/bin/bash

BASE_DIR="$(dirname $0)"
source $BASE_DIR/az-credentials.sh
source $BASE_DIR/utils.sh provisioner

usage(){
    echo -e "${GRAY}"
	echo "Usage: $0 "
	echo "  -a, --action <create|delete>        : Action [create | delete] to be performed"
	echo "  -i, --infra <az_resource_or_infra>  : Azure Resource or Infrastructure"
	echo "  -h, --help                          : Help"
	echo -e "${NC}"
	exit 1
}

[[ $# -ne 4 ]] && usage

while [[ $# -gt 1 ]]
do
key="$1"
case $key in
    -a|--action)
    ACTION="$2"
    [[ ${ACTION} != 'create' ]] && [[ ${ACTION} != 'delete' ]] && usage
    shift
    ;;
    -i|--infra)
    INFRA_RSRC="$2"
    [[ ! -d "terraform/${INFRA_RSRC}" ]] && exitWithErr "Missing infra code under terraform/${INFRA_RSRC}"
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

export ARM_SUBSCRIPTION_ID=${subscription_id}
export ARM_TENANT_ID=${tenant_id}
export ARM_CLIENT_ID=${client_id}
export ARM_CLIENT_SECRET=${client_secret}

logInfo "==================================================="
logInfo "Azure Details"
logInfo "==================================================="
logInfo "Subscription Id: ${ARM_SUBSCRIPTION_ID}"
logInfo "Tenant Id      : ${ARM_TENANT_ID}"
logInfo "Client Id      : ${ARM_CLIENT_ID}"
logInfo "==================================================="


cd terraform/${INFRA_RSRC}

logInfo "Validating infrastructure definitions ..."
terraform validate
exitOnErr "Invalid infrastructure definitions"

logInfo "Generating infrastructure plan"
if [ ${ACTION} == 'create' ]
then
    terraform plan
    exitOnErr "Error generating infrastructure plan"

    logInfo "Creating Infrastructure for ${INFRA_RSRC}"
    terraform apply
else
    terraform plan -destroy
    exitOnErr "Error generating infrastructure plan"

    logInfo "Destroying Infrastructure ${INFRA_RSRC}"
    terraform destroy -force
fi
exitOnErr "Error appling infrastructure changes"

logInfo "==================================================="