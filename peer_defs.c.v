module enet

struct C._ENetPeer {
pub:
	dispatchList                   C._ENetListNode
	host                           &C._ENetHost
	outgoingPeerID                 u16
	incomingPeerID                 u16
	connectID                      u32
	outgoingSessionID              byte
	incomingSessionID              byte
	address                        C._ENetAddress
	data                           voidptr
	state                          PeerState
	channels                       &C._ENetChannel
	channel_count                  size_t
	incomingBandwidth              u32
	outgoingBandwidth              u32
	incomingBandwidthThrottleEpoch u32
	outgoingBandwidthThrottleEpoch u32
	incomingDataTotal              u32
	outgoingDataTotal              u32
	lastSendTime                   u32
	lastReceivedTime               u32
	nextTimeout                    u32
	earliestTimeout                u32
	packetLossEpoch                u32
	packetsSent                    u32
	packetsLost                    u32
	packetLoss                     u32
	packetLossVariance             u32
	packetThrottle                 u32
	packetThrottleLimit            u32
	packetThrottleCounter          u32
	packetThrottleEpoch            u32
	packetThrottleAcceleration     u32
	packetThrottleDeceleration     u32
	packetThrottleInterval         u32
	pingInterval                   u32
	timeoutLimit                   u32
	timeoutMinimum                 u32
	timeoutMaximum                 u32
	lastRoundTripTime              u32
	lowestRoundTripTime            u32
	lastRoundTripTimeVariance      u32
	highestRoundTripTimeVariance   u32
	roundTripTime                  u32
	roundTripTimeVariance          u32
	mtu                            u32
	windowSize                     u32
	reliableDataTransit            u32
	outgoingReliableSequenceNumber u16
	acknowledgements               C._ENetList
	sentReliableCommands           C._ENetList
	sentUnreliableCommands         C._ENetList
	outgoingCommands               C._ENetList
	dispatchedCommands             C._ENetList
	flags                          u16
	reserver                       u16
	incomingUnsequencedGroup       u16
	outgoingUnsequencedGroup       u16
	unsequencedWindow              &u32 // [ENET_PEER_UNSEQUENCED_WINDOW_SIZE / 32]
	eventData                      u32
	totalWaitingData               size_t
}

fn C.enet_peer_send(&C._ENetPeer, byte, &C._ENetPacket) int

fn C.enet_peer_receive(&C._ENetPeer, byte) &C._ENetPacket

fn C.enet_peer_ping(&C._ENetPeer)

fn C.enet_peer_ping_interval(&C._ENetPeer, u32)

fn C.enet_peer_timeout(&C._ENetPeer, u32, u32, u32)

fn C.enet_peer_reset(&C._ENetPeer)

fn C.enet_peer_disconnect(&C._ENetPeer, u32)

fn C.enet_peer_disconnect_now(&C._ENetPeer, u32)

fn C.enet_peer_disconnect_later(&C._ENetPeer, u32)

fn C.enet_peer_throttle_configure(&C._ENetPeer, u32, u32, u32)
