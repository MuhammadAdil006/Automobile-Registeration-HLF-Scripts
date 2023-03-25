# Set environment variables
export FABRIC_LOGGING_SPEC=INFO
export CORE_PEER_ID=manufacturer-peer

cp $PWD/automobile/client/manufacturer/msp/admincerts/cert.pem $PWD/automobile/client/manufacturer/peer1/msp/admincerts/cert.pem


#peer1 for all organizations
IDENTITY=peer1
export CORE_PEER_MSPCONFIGPATH=$PWD/automobile/client/manufacturer/peer1/msp
export FABRIC_CFG_PATH="$PWD/automobile/client/manufacturer"
export CORE_PEER_LOCALMSPID="ManufacturerMSP"
echo "Done"
#ManufacturerMSP ,FbrMSP for other organizations
export GOPATH="$PWD/automobile/client/manufacturer/gopath"
export NODECHAINCODE="$PWD/automobile/client/manufacturer/nodechaincode"
VAR=$((PORT_NUMBER_BASE))
export CORE_PEER_FILESYSTEMPATH="$PWD/automobile/client/manufacturer"
export PEER_LOGS=$PWD/automobile/excise/manufacturer-peer
sudo -E mkdir -p $CORE_PEER_FILESYSTEMPATH

mkdir -p $PEER_LOGS
# Start the peer
sudo -E peer node start 2> $PEER_LOGS/peer.log






