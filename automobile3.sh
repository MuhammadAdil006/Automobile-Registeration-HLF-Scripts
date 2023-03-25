DIR="$( which $BASH_SOURCE)"
DIR="$(dirname $DIR)"
cd $DIR
export FABRIC_LOGGING_SPEC=INFO
export FABRIC_CFG_PATH=$PWD/automobile
configtxgen -profile AutomobileChannel -outputCreateChannelTx ./automobile/automobile-channel.tx -channelID automobilechannel

ORG_NAME=excise
CRYPTO_CONFIG_ROOT_FOLDER=$PWD/automobile/client
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/admin/msp
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<<${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"
CHANNEL_TX_FILE=$PWD/automobile/automobile-channel.tx
peer channel signconfigtx -f $CHANNEL_TX_FILE

echo "Excise Signed"
ORG_NAME=fbr
CRYPTO_CONFIG_ROOT_FOLDER=$PWD/automobile/client
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/admin/msp
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<<${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"
CHANNEL_TX_FILE=$PWD/automobile/automobile-channel.tx
peer channel signconfigtx -f $CHANNEL_TX_FILE
echo "FBR Signed"

ORDERER_ADDRESS="localhost:7050"
CHANNEL_TX_FILE="$PWD/automobile/automobile-channel.tx"
CRYPTO_CONFIG_ROOT_FOLDER=$PWD/automobile/client
IDENTITY="admin"
ORG_NAME=excise
export CORE_PEER_MSPCONFIGPATH=$CRYPTO_CONFIG_ROOT_FOLDER/$ORG_NAME/$IDENTITY/msp
MSP_ID="$(tr '[:lower:]' '[:upper:]' <<<${ORG_NAME:0:1})${ORG_NAME:1}"
export CORE_PEER_LOCALMSPID=$MSP_ID"MSP"
peer channel create -o $ORDERER_ADDRESS -c automobilechannel -f $CHANNEL_TX_FILE

echo "Submitting the channel TX to Orderer completed"

cd $PWD/automobile/client/excise/
mkdir peer1

cd $PWD/../fbr/
mkdir peer1

cd $PWD/../manufacturer/
mkdir peer1

cd $PWD/../../

cd $PWD/..
cp $DIR/SetupFiles/peer/excise/fabric-ca-client-config.yaml    $DIR/automobile/client/excise/peer1/fabric-ca-client-config.yaml
cp $DIR/SetupFiles/peer/fbr/fabric-ca-client-config.yaml    $DIR/automobile/client/fbr/peer1/fabric-ca-client-config.yaml
cp $DIR/SetupFiles/peer/manufacturer/fabric-ca-client-config.yaml    $DIR/automobile/client/manufacturer/peer1/fabric-ca-client-config.yaml

IDENTITY="admin"
ORG_NAME=excise
CA_CLIENT_FOLDER="automobile/client/$ORG_NAME"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME
PEER=peer1
fabric-ca-client register --id.type peer --id.name $PEER --id.secret pw --id.affiliation $ORG_NAME

IDENTITY=peer1
CA_CLIENT_FOLDER="automobile/client/$ORG_NAME"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
fabric-ca-client enroll -u http://$IDENTITY:pw@localhost:7054
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
CA_CLIENT_FOLDER="automobile/client/$ORG_NAME"

cp $PWD/automobile/client/excise/msp/admincerts/cert.pem    $PWD/automobile/client/excise/peer1/msp/admincerts/cert.pem
echo "Excise Peer1 Registered"

IDENTITY="admin"
ORG_NAME=fbr
CA_CLIENT_FOLDER="automobile/client/$ORG_NAME"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME
PEER=peer1
fabric-ca-client register --id.type peer --id.name $PEER --id.secret pw --id.affiliation $ORG_NAME

IDENTITY=peer1
CA_CLIENT_FOLDER="automobile/client/$ORG_NAME"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
fabric-ca-client enroll -u http://$IDENTITY:pw@localhost:7054
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
CA_CLIENT_FOLDER="automobile/client/$ORG_NAME"

cp $PWD/automobile/client/fbr/msp/admincerts/cert.pem    $PWD/automobile/client/fbr/peer1/msp/admincerts/cert.pem


IDENTITY="admin"
ORG_NAME=manufacturer
CA_CLIENT_FOLDER="automobile/client/$ORG_NAME"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME
PEER=peer1
fabric-ca-client register --id.type peer --id.name $PEER --id.secret pw --id.affiliation $ORG_NAME

IDENTITY=peer1
CA_CLIENT_FOLDER="automobile/client/$ORG_NAME"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
fabric-ca-client enroll -u http://$IDENTITY:pw@localhost:7054
mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts
CA_CLIENT_FOLDER="automobile/client/$ORG_NAME"

cp $PWD/automobile/client/fbr/msp/admincerts/cert.pem    $PWD/automobile/client/fbr/peer1/msp/admincerts/cert.pem

cp $DIR/SetupFiles/peer/manufacturer/core.yaml    $DIR/automobile/client/manufacturer/core.yaml
cp $DIR/SetupFiles/peer/fbr/core.yaml    $DIR/automobile/client/fbr/core.yaml
cp $DIR/SetupFiles/peer/excise/core.yaml    $DIR/automobile/client/excise/core.yaml

# Set environment variables
export FABRIC_LOGGING_SPEC=INFO
export CORE_PEER_ID=excise-peer

#peer1 for all organizations
IDENTITY=peer1
export CORE_PEER_MSPCONFIGPATH=$PWD/automobile/client/excise/peer1/msp
export FABRIC_CFG_PATH="$PWD/automobile/client/excise"
export CORE_PEER_LOCALMSPID="ExciseMSP"

#ManufacturerMSP ,FbrMSP for other organizations
export GOPATH="$PWD/automobile/client/excise/gopath"
export NODECHAINCODE="$PWD/automobile/client/excise/nodechaincode"
VAR=$((PORT_NUMBER_BASE))
export CORE_PEER_FILESYSTEMPATH="$PWD/automobile/client/excise"
export PEER_LOGS=$PWD/automobile/excise/excise-peer
sudo -E mkdir -p $CORE_PEER_FILESYSTEMPATH

mkdir -p $PEER_LOGS
# Start the peer
sudo -E peer node start 2> $PEER_LOGS/peer.log




# Set environment variables
export FABRIC_LOGGING_SPEC=INFO
export CORE_PEER_ID=fbr-peer

#peer1 for all organizations
IDENTITY=peer1
export CORE_PEER_MSPCONFIGPATH=$PWD/automobile/client/fbr/peer1/msp
export FABRIC_CFG_PATH="$PWD/automobile/client/fbr"
export CORE_PEER_LOCALMSPID="FbrMSP"
echo "Done"
#ManufacturerMSP ,FbrMSP for other organizations
export GOPATH="$PWD/automobile/client/fbr/gopath"
export NODECHAINCODE="$PWD/automobile/client/fbr/nodechaincode"
VAR=$((PORT_NUMBER_BASE))
export CORE_PEER_FILESYSTEMPATH="$PWD/automobile/client/fbr"
export PEER_LOGS=$PWD/automobile/excise/fbr-peer
sudo -E mkdir -p $CORE_PEER_FILESYSTEMPATH

mkdir -p $PEER_LOGS
# Start the peer
sudo -E peer node start 2> $PEER_LOGS/peer.log












