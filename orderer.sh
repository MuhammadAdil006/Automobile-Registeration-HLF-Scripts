# ROOT_FOLDER=./automobile/client
# export ORDERER_FILELEDGER_LOCATION=$ROOT_FOLDER/orderer/ledger

 export ORDERER_FILELEDGER_LOCATION="./client/orderer/ledger"

 echo $ORDERER_FILELEDGER_LOCATION

export FABRIC_LOGGING_SPEC=INFO
export FABRIC_CFG_PATH=./automobile
echo $FABRIC_CFG_PATH
orderer