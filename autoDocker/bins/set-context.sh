#!/bin/bash
#Sets the context for native peer commands

function usage {
    echo "Usage:             . ./set-context.sh  ORG_NAME"
    echo "Usage with TLS     . ./set-context.sh  ORG_NAME  tls"
    echo "           Sets the organization context for native peer execution"
}

if [ "$1" == "" ]; then
    usage
    exit
fi

export ORG_CONTEXT=$1
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<< ${ORG_CONTEXT:0:1})${ORG_CONTEXT:1}"
export ORG_NAME=$MSP_ID

# Added this Oct 22
export CORE_PEER_LOCALMSPID=$ORG_NAME"MSP"

# Logging specifications
export FABRIC_LOGGING_SPEC=INFO

# Location of the core.yaml
export FABRIC_CFG_PATH=$PWD/config/$1
echo $FABRIC_CFG_PATH
# Address of the peer
export CORE_PEER_ADDRESS=peer1.$1.com:7055
if [ "$ORG_CONTEXT" == "fbr" ]; then
    # Native binary uses the local port on VM 
    export CORE_PEER_ADDRESS=peer1.$1.com:8060
fi
if [ "$ORG_CONTEXT" == "manufacturer" ]; then
    # Native binary uses the local port on VM 
    export CORE_PEER_ADDRESS=peer1.$1.com:8065
fi
# Local MSP for the admin - Commands need to be executed as org admin

export CORE_PEER_MSPCONFIGPATH=$PWD/config/crypto-config/peerOrganizations/$1.com/users/Admin@$1.com/msp
echo $CORE_PEER_MSPCONFIGPATH
# Address of the orderer
export ORDERER_ADDRESS=orderer.acme.com:7050

# RAFT requires TLS
if [ "$2" == "tls" ] || [ "$2" == "raft" ] ; then

    export ORDERER_CA_ROOTFILE=$PWD/config/crypto-config/ordererOrganizations/excise.com/orderers/orderer.excise.com/msp/tlscacerts/tlsca.excise.com-cert.pem

    export CORE_PEER_TLS_ROOTCERT_FILE=$PWD/config/crypto-config/peerOrganizations/$1.com/peers/peer1.$1.com/tls/ca.crt

    export CORE_PEER_TLS_ENABLED=true
    
else
    export CORE_PEER_TLS_ENABLED=false
fi

#### Introduced in Fabric 2.x update
#### Test Chaincode related properties
export CC_CONSTRUCTOR='{"Args":["init","Pkr","10000000","Pakistani Rupee!!!","MAdil"]}'
export CC_NAME="gocc"
export CC_PATH="supplychain"
export CC_VERSION="1.0"
export CC_CHANNEL_ID="automobilechannel"
export CC_LANGUAGE="golang"

# Version 2.x
export INTERNAL_DEV_VERSION="1.0"
export CC2_PACKAGE_FOLDER="$HOME/packages"
export CC2_SEQUENCE=1
export CC2_INIT_REQUIRED="--init-required"

# Create the package with this name
export PACKAGE_NAME="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION.tar.gz"
# Extracts the package ID for the installed chaincode
export LABEL="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION"
