module enet

import strconv

// Address contains an IPv4 address and a port, used to contact a peer
pub type Address = C._ENetAddress

// new_address creates an Address from a string. It can use string representation of
// an IPv4 address (e.g. `1.1.1.1`) or a domain name (`localhost` or `example.com`).
// The port is optional and separated with `:`.
pub fn new_address(addr string) ?&Address {
	mut host := ''
	mut port := u16(0)
	if addr.contains(':') {
		split := addr.split_nth(':', 2)
		host = split[0]
		port = u16(strconv.parse_uint(split[1], 10, 16))
		if port == 0 {
			return error('invalid port')
		}
	} else {
		host = addr
	}
	mut address := &Address{
		port: port
	}
	address.set_host_name(host) or { return error('invalid host') }
	return address
}

// set_host_ip parses a string representation of an IPv4 address and sets the host of the address
pub fn (mut a Address) set_host_ip(host_ip string) ? {
	errcode := C.enet_address_set_host_ip(unsafe { &C._ENetAddress(a) }, host_ip.str)
	if errcode != 0 {
		return error_with_code('unable to set host ip `$host_ip`', errcode)
	}
}

// set_host_name parses either a string representaion of an IPv4 address or a domain name
// and sets it as the host of the address.
pub fn (mut a Address) set_host_name(host_name string) ? {
	errcode := C.enet_address_set_host(unsafe { &C._ENetAddress(a) }, host_name.str)
	if errcode != 0 {
		return error_with_code('unable to set host name `$host_name`', errcode)
	}
}

// get_host_ip returns the string representation of the currently set host of the address
pub fn (a &Address) get_host_ip() ?string {
	str_len := C.INET_ADDRSTRLEN
	str := unsafe { charptr(malloc(str_len)) }
	errcode := C.enet_address_get_host_ip(unsafe { &C._ENetAddress(a) }, str, str_len)
	if errcode != 0 {
		return error_with_code('unable to get host ip', errcode)
	}
	unsafe {
		vstr := cstring_to_vstring(byteptr(str))
		free(str)
		return vstr
	}
}
