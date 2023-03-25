DIR="$( which $BASH_SOURCE)"
DIR="$(dirname $DIR)"
cd $DIR/automobile

export FABRIC_CA_CLIENT_HOME=$PWD/client/caserver/admin
fabric-ca-client enroll -u http://admin:pw@localhost:7054

cd $DIR/client
mkdir manufacturer
mkdir excise
mkdir fbr
mkdir orderer

cd $DIR/manufacturer
mkdir admin

cd $DIR/..
cd $DIR/excise
mkdir admin

cd $DIR/..
cd $DIR/fbr
mkdir admin

cd $DIR/..
cd $DIR/orderer
mkdir admin

cd $DIR/../..
ROOT_FOLDER=$PWD/..
echo "----------------------------------------------"

cp $ROOT_FOLDER/SetupFiles/ca-client-yaml/excise/fabric-ca-client-config.yaml  $ROOT_FOLDER/automobile/client/excise/admin/fabric-ca-client-config.yaml
cp $ROOT_FOLDER/SetupFiles/ca-client-yaml/fbr/fabric-ca-client-config.yaml  $ROOT_FOLDER/automobile/client/fbr/admin/fabric-ca-client-config.yaml
cp $ROOT_FOLDER/SetupFiles/ca-client-yaml/manufacturer/fabric-ca-client-config.yaml  $ROOT_FOLDER/automobile/client/manufacture/admin/fabric-ca-client-config.yaml
cp $ROOT_FOLDER/SetupFiles/ca-client-yaml/orderer/fabric-ca-client-config.yaml  $ROOT_FOLDER/automobile/client/orderer/admin/fabric-ca-client-config.yaml

echo "----------------------------------------------"
export FABRIC_CA_CLIENT_HOME=$PWD/client/caserver/admin


ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'

echo "Excise Admin"
fabric-ca-client register --id.type client --id.name Excise-admin --id.secret pw --id.affiliation excise --id.attrs $ATTRIBUTES

ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
echo "FBR Admin"
fabric-ca-client register --id.type client --id.name Fbr-admin --id.secret pw --id.affiliation fbr --id.attrs $ATTRIBUTES

ATTRIBUTES='"hf.Registrar.Roles=orderer"'
echo "Orderer Admin"
fabric-ca-client register --id.type client --id.name Orderer-admin --id.secret pw --id.affiliation excise --id.attrs $ATTRIBUTES

ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
echo "Manufacture Admin"
fabric-ca-client register --id.type client --id.name Manufacturer-admin --id.secret pw --id.affiliation manufacturer --id.attrs $ATTRIBUTES

echo "----------------------------------------------"

export FABRIC_CA_CLIENT_HOME=$PWD/client/excise/admin
fabric-ca-client enroll -u http://Excise-admin:pw@localhost:7054
export FABRIC_CA_CLIENT_HOME=$PWD/client/fbr/admin
fabric-ca-client enroll -u http://Fbr-admin:pw@localhost:7054
export FABRIC_CA_CLIENT_HOME=$PWD/client/manufacturer/admin
fabric-ca-client enroll -u http://Manufacturer-admin:pw@localhost:7054
export FABRIC_CA_CLIENT_HOME=$PWD/client/orderer/admin
fabric-ca-client enroll -u http://Orderer-admin:pw@localhost:7054

echo "----------------------------------------------"


cd $DIR/client

cd $DIR/excise/admin/msp
mkdir admincerts

cd $DIR/../../..

cd $DIR/fbr/admin/msp
mkdir admincerts

cd $DIR/../../..

cd $DIR/manufacturer/admin/msp
mkdir admincerts

cd $DIR/../../..

cd $DIR/orderer/admin/msp
mkdir admincerts

cd $DIR/../../..

echo "----------------------------------------------"

# #● Make a subfolder admincerts within each orgnization msp subfolder of admin
# #[organization_name]/admin/msp/admincerts
echo "Copying admincerts"
ROOT_FOLDER=$PWD
cp $ROOT_FOLDER/caserver/admin/msp/signcerts/cert.pem   $DIR/orderer/admin/msp/admincerts/cert.pem
cp $ROOT_FOLDER/caserver/admin/msp/signcerts/cert.pem   $DIR/manufacturer/admin/msp/admincerts/cert.pem
cp $ROOT_FOLDER/caserver/admin/msp/signcerts/cert.pem   $DIR/excise/admin/msp/admincerts/cert.pem
cp $ROOT_FOLDER/caserver/admin/msp/signcerts/cert.pem   $DIR/fbr/admin/msp/admincerts/cert.pem

cd $DIR/excise
mkdir msp
cd $DIR/msp
mkdir cacerts
mkdir admincerts
mkdir keystore

cd $DIR/../..

cd $DIR/fbr
mkdir msp
cd $DIR/msp
mkdir cacerts
mkdir admincerts
mkdir keystore

cd $DIR/../..

cd $DIR/manufacturer
mkdir msp
cd $DIR/msp
mkdir cacerts
mkdir admincerts
mkdir keystore

cd $DIR/../..

cd $DIR/orderer
mkdir msp
cd $DIR/msp
mkdir cacerts
mkdir admincerts
mkdir keystore

cd $DIR/../..

cp $ROOT_FOLDER/../server/ca-cert.pem   $ROOT_FOLDER/../client/excise/msp/cacerts/ca-cert.pem
cp $ROOT_FOLDER/../server/ca-cert.pem   $ROOT_FOLDER/../client/fbr/msp/cacerts/ca-cert.pem
cp $ROOT_FOLDER/../server/ca-cert.pem   $ROOT_FOLDER/../client/manufacturer/msp/cacerts/ca-cert.pem
cp $ROOT_FOLDER/../server/ca-cert.pem   $ROOT_FOLDER/../client/orderer/msp/cacerts/ca-cert.pem

cp $ROOT_FOLDER/excise/admin/msp/signcerts/cert.pem   $ROOT_FOLDER/excise/msp/admincerts/cert.pem
cp $ROOT_FOLDER/fbr/admin/msp/signcerts/cert.pem   $ROOT_FOLDER/fbr/msp/admincerts/cert.pem
cp $ROOT_FOLDER/manufacturer/admin/msp/signcerts/cert.pem   $ROOT_FOLDER/manufacturer/msp/admincerts/cert.pem
cp $ROOT_FOLDER/orderer/admin/msp/signcerts/cert.pem   $ROOT_FOLDER/orderer/msp/admincerts/cert.pem

cp $ROOT_FOLDER/../../SetupFiles/configtx.yaml   $ROOT_FOLDER/../configtx.yaml
cp $ROOT_FOLDER/../../SetupFiles/orderer.yaml   $ROOT_FOLDER/../orderer.yaml
cp $ROOT_FOLDER/../../SetupFiles/core.yaml   $ROOT_FOLDER/../core.yaml


echo "----------------------------------------------"
echo "Orderer - Creating Genesis Block"
export FABRIC_LOGGING_SPEC=INFO
cd $PWD/..
export FABRIC_CFG_PATH=$PWD
echo $FABRIC_CFG_PATH

configtxgen -profile AutomobileOrdererGenesis -outputBlock ./automobile-genesis.block -channelID ordererchannel

IDENTITY="admin"
CA_CLIENT_FOLDER="client/orderer"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
ADMIN_CLIENT_HOME=$FABRIC_CA_CLIENT_HOME
# Register orderer
fabric-ca-client register --id.type orderer --id.name orderer --id.secret pw --id.affiliation excise

IDENTITY="orderer"
CA_CLIENT_FOLDER="client/orderer"
export FABRIC_CA_CLIENT_HOME="$CA_CLIENT_FOLDER/$IDENTITY"
echo $FABRIC_CA_CLIENT_HOME
# Enroll admin
fabric-ca-client enroll -u http://orderer:pw@localhost:7054
echo "Enrollment"
echo $FABRIC_CA_CLIENT_HOME
echo $ADMIN_CLIENT_HOME
cd $ROOT_FOLDER/orderer/orderer/msp
mkdir admincerts
cd $ROOT_FOLDER/../../..
cp $ROOT_FOLDER/orderer/admin/msp/signcerts/cert.pem    $ROOT_FOLDER/orderer/orderer/msp/admincerts/cert.pem

export ORDERER_FILELEDGER_LOCATION=$ROOT_FOLDER/orderer/ledger
echo $ORDERER_FILELEDGER_LOCATION

export FABRIC_LOGGING_SPEC=INFO
export FABRIC_CFG_PATH=$ROOT_FOLDER/..
echo $FABRIC_CFG_PATH
cd $ROOT_FOLDER/../..
echo $DIR
echo $ROOT_FOLDER/..
orderer

