module enet

struct C._ENetAddress {
pub:
	host u32
	port u16
}

fn C.enet_address_set_host_ip(&C._ENetAddress, charptr) int

fn C.enet_address_set_host(&C._ENetAddress, charptr) int

fn C.enet_address_get_host_ip(&C._ENetAddress, charptr, size_t) int

fn C.enet_address_get_host(&C._ENetAddress, charptr, size_t) int
