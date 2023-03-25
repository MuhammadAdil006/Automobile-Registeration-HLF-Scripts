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
