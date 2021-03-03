module enet

pub enum EventType {
	// An event of type `.none` is returned if no event occurred within the specified time limit.
	none_ = C.ENET_EVENT_TYPE_NONE
	// An event of type `.connect` is returned when either a new client host has connected
	// to the server host or when an attempt to establish a connection with a foreign host
	// has succeeded. Only the "peer" field of the event structure is valid for this event
	// and contains the newly connected peer.
	connect = C.ENET_EVENT_TYPE_CONNECT
	// An event of type `.receive` is returned when a packet is received from a connected peer.
	// The `peer` field contains the peer the packet was received from,
	// `channelID` is the channel on which the packet was sent,
	// and `packet` is the packet that was sent.
	// The packet contained in the `packet` field must be destroyed with `packet.destroy()`
	// (or the equivalent `packet.free()`) when you are done inspecting its contents.
	receive = C.ENET_EVENT_TYPE_RECEIVE
	// An event of type `.disconnect` is returned when a connected peer has either explicitly
	// disconnected or timed out. Only the `peer` field of the event structure is valid for
	// this event and contains the peer that disconnected. Only the `data` field of the peer
	// is still valid on a disconnect event and must be explicitly reset.
	disconnect = C.ENET_EVENT_TYPE_DISCONNECT
}

pub type Event = C._ENetEvent

[inline]
pub fn (e &Event) peer() &Peer {
	return &Peer(e.peer)
}

[inline]
pub fn (e &Event) packet() &Packet {
	return &Packet(e.packet)
}
