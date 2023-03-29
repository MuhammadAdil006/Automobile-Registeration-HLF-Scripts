first time

cd autoDocker
./init-setup.sh


2nd time

cd autoDocker
./launch.sh
./shutdown.sh



<!-- chaincode installations

export CC_NAME=gocc
export CC_VERSION=1.0
export CC_LABEL="$CC_NAME.$CC_VERSION-1.0"
export CC_PACKAGE_FILE=$HOME/packages/$CC_LABEL.tar.gz


mkdir -p $HOME/packages

. bins/set-context.sh excise

peer lifecycle chaincode package $CC_PACKAGE_FILE --label $CC_LABEL -p supplychain -->