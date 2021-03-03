module enet

// A Packet is the basic unit that can be sent to a peer.
pub type Packet = C._ENetPacket

// PacketFlags define some behavior about a specific packet
[flag]
pub enum PacketFlags {
	reliable
	unsequenced
	no_allocate
	unreliable_fragment
	flag_sent
}

// new_packet creates a packet with specific data and flags
[inline]
pub fn new_packet(data []byte, flags PacketFlags) ?&Packet {
	return &Packet(C.enet_packet_create(data.data, data.len, u32(flags)))
}

[inline]
[unsafe]
pub fn (mut p Packet) free() {
	C.enet_packet_destroy(unsafe { &C._ENetPacket(p) })
}

[inline]
pub fn (p &Packet) data() []byte {
	mut data := []byte{}
	data = array{
		element_size: int(sizeof(byte))
		data: p.data
		len: int(p.dataLength)
		cap: int(p.dataLength)
	}
	return data
}

[inline]
pub fn (p &Packet) flags() PacketFlags {
	return PacketFlags(p.flags)
}

// resize attempts to resize the data in the packet to length specified in the
// data_length parameter
[inline]
pub fn (mut p Packet) resize(data_length size_t) ? {
	errcode := C.enet_packet_resize(unsafe { &C._ENetPacket(p) }, data_length)
	if errcode < 0 {
		return error_with_code('unable to resize packet', errcode)
	}
}
