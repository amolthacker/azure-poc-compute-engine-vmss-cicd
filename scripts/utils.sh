#!/bin/bash

###################
# ANSI COLORS
###################
RED='\033[0;31m'
GREEN='\033[0;32m'
GRAY='\033[0;37m'
NC='\033[0m'
###################

function datetime {
    echo `date +%m-%d-%yT%H:%M:%S`
}

function datetimefmtd {
    echo $(datetime) | sed 's/[-:]/_/g'
}

function usage {
    echo  -e "${GRAY} $0 <baker|provisioner> [eg: utils.sh baker] ${NC}"
    exit 1
}

[[ $# -ne 1 ]] && usage
PROG=$1


function logInfo {
    echo -e "$(datetime) ${PROG} [${GREEN}INFO${NC}] $@"
}

function logErr {
    echo -e "$(datetime) ${PROG} [${RED}ERROR${NC}] $@"
}

function exitWithErr {
    if [ $# -gt 0 ]
    then
        logErr $@
    fi
    exit 1
}

function exitOnErr {
    if [ $? -ne 0 ]
    then
        exitWithErr $@
    fi
}