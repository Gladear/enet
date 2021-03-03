module enet

import time

// A Host can either be a server or a client. They share most of their fonctionnalities,
// but are't initialized the same way. To clearly differentiate the two initializations,
// two functions are available : `new_client` and `new_server`. Still, both return an Host
pub type Host = C._ENetHost

pub const (
	// host_any is used to specify the default server host
	host_any       = u32(C.ENET_HOST_ANY)
	// host_broadcast is used to speficy the broadcast address.
	// This makes sense for `Host.connect`, but not for `new_server`. Once a server
	// responds ti a broadcast, the address is updated to the server's actual IP address
	host_broadcast = u32(C.ENET_HOST_BROADCAST)
	// port_any must be used for something, but what ???
	port_any       = u16(C.ENET_PORT_ANY)
)

// ServerConfig has many default values to make server creations easier
pub struct ServerConfig {
	// addr is the address on which the server will be served
	// serve on any host, any port by default
	addr Address = Address{host_any, port_any}
	// port is a convenient way to use the default host but change
	// the port, it is therefore ignored if the port is set in `addr`
	port u16
	// peer_count is the maximum number of client connected at the same time
	// allow up to 32 clients by default
	peer_count u32 = 32
	// channel_limit is the number of channels by client
	// allow up to 2 channels to be used by default
	channel_limit u32 = 2
	// limitless bandwidth by default
	incoming_bandwidth u32
	outgoing_bandwidth u32
}

// new_server creates a new server host. Its main difference with a client is that
// an address must be set. Otherwise, server and client share most of their
// capabilities, hence the common type `Host`
[inline]
pub fn new_server(config ServerConfig) ?&Host {
	addr := &Address{
		host: config.addr.host
		port: if config.addr.port == port_any { config.port } else { config.addr.port }
	}
	server := &Host(C.enet_host_create(unsafe { &C._ENetAddress(addr) }, size_t(config.peer_count),
		size_t(config.channel_limit), config.incoming_bandwidth, config.outgoing_bandwidth))
	if isnil(server) {
		return error('unable to create an ENet server host')
	}
	return server
}

// ServerConfig has many default values to make client creations easier
pub struct ClientConfig {
	// peer_count is the maximum number of server connected at the same time
	// allow only one connection at a time
	peer_count u32 = 1
	// channel_limit is the number of channels by host
	// allow up to 2 channels to be used by default
	channel_limit u32 = 2
	// limitless bandwidth by default
	incoming_bandwidth u32
	outgoing_bandwidth u32
}

// new_client creates a new client host. Its main difference with a server is that
// no address must be set. Otherwise, server and client share most of their
// capabilities, hence the common type `Host`
[inline]
pub fn new_client(config ClientConfig) ?&Host {
	client := &Host(C.enet_host_create(0, size_t(config.peer_count), size_t(config.channel_limit),
		config.incoming_bandwidth, config.outgoing_bandwidth))
	if isnil(client) {
		return error('unable to create an ENet host')
	}
	return client
}

// ConnectConfig has many default values to make the connection to new peers easier.
// Only the address of the remote host `addr` is mandatory.
struct ConnectConfig {
	// addr is the address of the remote host
	addr &Address
	// channel_count is the number of channel used to communicate with the remote host
	channel_count u32 = 2
	// data is some arbitrary data sent to the new peer
	data u32
	// dont_wait indicates the function to return immediately after starting
	// to connect, instead of waiting for the acknowledgement.
	// To ensure that you correctly connected, you will have to call `.service`
	// and check that the next event's type is `.connect`
	dont_wait bool
	// wait_timeout determines the time to wait before considering the connection
	// to the remote host as failed. It is ignored it `dont_wait` is set tu `true`
	wait_timeout time.Duration = 30 * time.second
}


// connect allows the host to connect to a new peer.
[inline]
pub fn (mut h Host) connect(config ConnectConfig) ?&Peer {
	peer := &Peer(C.enet_host_connect(unsafe { &C._ENetHost(h) }, unsafe { &C._ENetAddress(config.addr) },
		size_t(config.channel_count), config.data))
	if isnil(peer) {
		return error('unable to start connection to peer')
	}
	// early return if the used asked not to wait for the acknoledgement of the connection
	if config.dont_wait {
		return peer
	}
	wait_end := time.now().add(config.wait_timeout)
	for {
		remaining_wait := wait_end - time.now()
		event := h.service(u32(remaining_wait)) ?
		match event.@type {
			.none_, .receive {}
			.connect {
				return peer
			}
			.disconnect {
				return error('unable to connect to peer')
			}
		}
	}
	return error('connection timed out')
}

[inline]
[unsafe]
pub fn (mut h Host) free() {
	C.enet_host_destroy(unsafe { &C._ENetHost(h) })
}

// check_events checks for any queued events on the host and dispatches one if available.
[inline]
pub fn (h &Host) check_events() ?&Event {
	mut event := &Event{
		peer: 0
		packet: 0
	}
	errcode := C.enet_host_check_events(unsafe { &C._ENetHost(h) }, unsafe { &C._ENetEvent(event) })
	if errcode < 0 {
		return error_with_code('unable to check for host events', errcode)
	}
	return event
}

// service waits for events on the host and shuttles packets between the host
// and its peers.
// service should be called faily regularly for adequate performance.
[inline]
pub fn (h &Host) service(timeout u32) ?&Event {
	mut event := &Event{
		peer: 0
		packet: 0
	}
	errcode := C.enet_host_service(unsafe { &C._ENetHost(h) }, unsafe { &C._ENetEvent(event) },
		timeout)
	if errcode < 0 {
		return error_with_code('unable to service host', errcode)
	}
	return event
}

// flush sends any queued packets on the host specified to its designated peers.
// this function need only be used in circumstances where one wishes to send
// queued packets earlier than in a call to `service`.
[inline]
pub fn (mut h Host) flush() {
	C.enet_host_flush(unsafe { &C._ENetHost(h) })
}

// broadcast queues a packet to be sent to all peers associated with the host.
[inline]
pub fn (mut h Host) broadcast(channel_id byte, packet &Packet) {
	C.enet_host_broadcast(unsafe { &C._ENetHost(h) }, channel_id, unsafe { &C._ENetPacket(packet) })
}

// compress sets the packet compressor the host should use to compress and decompress packets.
[inline]
pub fn (mut h Host) compress(compressor &Compressor) {
	C.enet_host_compress(unsafe { &C._ENetHost(h) }, unsafe { &C._ENetCompressor(compressor) })
}

// compress_with_range_coder sets the packet compressor the host should use to the default range coder.
[inline]
pub fn (mut h Host) compress_with_range_coder() ? {
	errcode := C.enet_host_compress_with_range_coder(unsafe { &C._ENetHost(h) })
	if errcode < 0 {
		return error_with_code('unable to set default compressor', errcode)
	}
}

// channel_limit limits the maximum allowed channels of future incoming connections.
// If set to 0, then this is equivalent to ENET_PROTOCOL_MAXIMUM_CHANNEL_COUNT.
[inline]
pub fn (mut h Host) channel_limit(channel_limit size_t) {
	C.enet_host_channel_limit(unsafe { &C._ENetHost(h) }, channel_limit)
}

// bandwidth_limit adjusts the bandwidth limits of a host.
[inline]
pub fn (mut h Host) bandwidth_limit(incoming u32, outgoing u32) {
	C.enet_host_bandwidth_limit(unsafe { &C._ENetHost(h) }, incoming, outgoing)
}
