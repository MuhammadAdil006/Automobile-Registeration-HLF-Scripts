CORE_PEER_MSPCONFIGPATH=$PWD/automobile/client/excise/admin/msp
export FABRIC_CFG_PATH="$PWD/automobile/client/excise"
# Fetch channel configuration
# peer channel fetch config $AUTOMOBILE_CHANNEL_BLOCK -o $ORDERER_ADDRESS -c airlinechannel
peer channel fetch 0 ./automobilechannel.block -o localhost:7050 -c automobilechannel
# Join the channel
peer channel join -o localhost:7050 -b ./automobilechannel.block


# export CORE_PEER_MSPCONFIGPATH=$PWD/automobile/client/fbr/admin/msp
export FABRIC_CFG_PATH="$PWD/automobile/client/fbr"
# # Fetch channel configuration
# peer channel fetch 0 ./automobilechannel.block -o localhost:7050 -c automobilechannel
# # Join the channel
export CORE_PEER_MSPCONFIGPATH=$PWD/automobile/client/fbr/admin/msp
peer channel join -o localhost:7050 -b ./automobilechannel.block

#Set environment variables

export FABRIC_CFG_PATH="$PWD/automobile/client/manufacturer"
# Fetch channel configuration
# peer channel fetch 0 ./automobilechannel.block -o localhost:7050 -c automobilechannel
# # Join the channel

export CORE_PEER_MSPCONFIGPATH=$PWD/automobile/client/manufacturer/admin/msp
peer channel join -o localhost:7050 -b ./automobilechannel.block manufaturer

