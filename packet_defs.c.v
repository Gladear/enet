module enet

struct C._ENetPacket {
pub:
	referenceCount size_t
	flags          u32
	data           byteptr
	dataLength     size_t
	freeCallback   C._ENetPacketFreeCallback
	userData       voidptr
}

fn C.enet_packet_create(voidptr, size_t, u32) &C._ENetPacket

fn C.enet_packet_destroy(&C._ENetPacket)

fn C.enet_packet_resize(&C._ENetPacket, size_t) int
