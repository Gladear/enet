module enet

struct C._ENetHost {
pub:
	socket                     C.ENetSocket
	address                    C._ENetAddress
	incomingBandwidth          u32
	outgoingBandwidth          u32
	bandwidthThrottleEpoch     u32
	mtu                        u32
	randomSeed                 u32
	recalculateBandwidthLimits int
	peers                      &C._ENetPeer
	peerCount                  size_t
	channelLimit               size_t
	serviceTime                u32
	dispatchQueue              C._ENetList
	continueSending            int
	packetSize                 size_t
	headerFlags                u16
	commands                   [32]C.ENetProtocol // [C.ENET_PROTOCOL_MAXIMUM_PACKET_COMMANDS]
	commandCount               size_t
	buffers                    &C.ENetBuffer // [C.ENET_BUFFER_MAXIMUM]
	bufferCount                size_t
	checksum                   C.ENetChecksumCallback
	compressor                 C._ENetCompressor
	packetData                 [2][4096]byte // [2][C.ENET_PROTOCOL_MAXIMUM_MTU]
	receivedAddress            C._ENetAddress
	receivedData               byteptr
	receivedDataLength         size_t
	totalSentData              u32
	totalSentPackets           u32
	totalReceivedData          u32
	totalReceivedPackets       u32
	intercept                  C.ENetInterceptCallback
	connectedPeers             size_t
	bandwidthLimitedPeers      size_t
	duplicatePeers             size_t
	maximumPacketSize          size_t
	maximumWaitingData         size_t
}

fn C.enet_host_create(&C._ENetAddress, size_t, size_t, u32, u32) &C._ENetHost

fn C.enet_host_destroy(&C._ENetHost)

fn C.enet_host_connect(&C._ENetHost, &C._ENetAddress, size_t, u32) &C._ENetPeer

fn C.enet_host_check_events(&C._ENetHost, &C._ENetEvent) int

fn C.enet_host_service(&C._ENetHost, &C._ENetEvent, u32) int

fn C.enet_host_flush(&C._ENetHost)

fn C.enet_host_broadcast(&C._ENetHost, byte, &C._ENetPacket)

fn C.enet_host_compress(&C._ENetHost, &C._ENetCompressor)

fn C.enet_host_compress_with_range_coder(&C._ENetHost) int

fn C.enet_host_channel_limit(&C._ENetHost, size_t)

fn C.enet_host_bandwidth_limit(&C._ENetHost, u32, u32)
