module enet

pub enum PeerState {
	disconnected = C.ENET_PEER_STATE_DISCONNECTED
	connecting = C.ENET_PEER_STATE_CONNECTING
	acknowledging_connect = C.ENET_PEER_STATE_ACKNOWLEDGING_CONNECT
	connection_pending = C.ENET_PEER_STATE_CONNECTION_PENDING
	connection_succeeded = C.ENET_PEER_STATE_CONNECTION_SUCCEEDED
	connected = C.ENET_PEER_STATE_CONNECTED
	disconnect_later = C.ENET_PEER_STATE_DISCONNECT_LATER
	disconnecting = C.ENET_PEER_STATE_DISCONNECTING
	acknowledging_disconnect = C.ENET_PEER_STATE_ACKNOWLEDGING_DISCONNECT
	zombie = C.ENET_PEER_STATE_ZOMBIE
}

pub type Peer = C._ENetPeer

[inline]
pub fn (mut p Peer) send(channel_id byte, packet &Packet) ? {
	errcode := C.enet_peer_send(unsafe { &C._ENetPeer(p) }, channel_id, unsafe { &C._ENetPacket(packet) })
	if errcode < 0 {
		return error_with_code('unable to send packet', errcode)
	}
}

[inline]
pub fn (mut p Peer) receive() ?(byte, &Packet) {
	mut channel_id := byte(0)
	packet := C.enet_peer_receive(unsafe { &C._ENetPeer(p) }, &channel_id)
	if isnil(packet) {
		return none
	}
	return channel_id, packet
}

[inline]
pub fn (mut p Peer) ping() {
	C.enet_peer_ping(unsafe { &C._ENetPeer(p) })
}

[inline]
pub fn (mut p Peer) ping_interval(interval u32) {
	C.enet_peer_ping_interval(unsafe { &C._ENetPeer(p) }, interval)
}

[inline]
pub fn (mut p Peer) timeout(limit u32, minimum u32, maximum u32) {
	C.enet_peer_timeout(unsafe { &C._ENetPeer(p) }, limit, minimum, maximum)
}

[inline]
pub fn (mut p Peer) reset() {
	C.enet_peer_reset(unsafe { &C._ENetPeer(p) })
}

[inline]
pub fn (mut p Peer) disconnect(data u32) {
	C.enet_peer_disconnect(unsafe { &C._ENetPeer(p) }, data)
}

[inline]
pub fn (mut p Peer) disconnect_now(data u32) {
	C.enet_peer_disconnect_now(unsafe { &C._ENetPeer(p) }, data)
}

[inline]
pub fn (mut p Peer) disconnect_later(data u32) {
	C.enet_peer_disconnect_later(unsafe { &C._ENetPeer(p) }, data)
}

[inline]
pub fn (mut p Peer) throttle_configure(interval u32, acceleration u32, deceleration u32) {
	C.enet_peer_throttle_configure(unsafe { &C._ENetPeer(p) }, interval, acceleration,
		deceleration)
}
