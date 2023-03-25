DIR="$( which $BASH_SOURCE)"
DIR="$(dirname $DIR)"

mkdir automobile
cd $DIR/automobile
mkdir client
mkdir server
mkdir ca-server-yaml
mkdir ca-client-yaml

cd $DIR/client
mkdir caserver

cd $DIR/caserver
mkdir admin
cd $DIR/../..

ROOT_FOLDER=$PWD/..
echo "----------------------------------------------"
cp $ROOT_FOLDER/SetupFiles/fabric-ca-server-config.yaml  $ROOT_FOLDER/automobile/ca-server-yaml/fabric-ca-server-config.yaml

cp $ROOT_FOLDER/SetupFiles/ca-client-yaml/fabric-ca-client-config.yaml  $ROOT_FOLDER/automobile/ca-client-yaml/fabric-ca-client-config.yaml

echo "----------------------------------------------"

cp $ROOT_FOLDER/SetupFiles/fabric-ca-server-config.yaml $ROOT_FOLDER/automobile/server/fabric-ca-server-config.yaml

echo $ROOT_FOLDER

export FABRIC_CA_SERVER_HOME=$PWD/server
fabric-ca-server start