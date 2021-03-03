module enet

fn test_new_address() {
	a1 := new_address('1.1.1.1:9000') or {
		assert false
		(&Address{})
	}
	assert a1.host == 0x01010101
	assert a1.port == 9000
	a2 := new_address('192.168.0.1') or {
		assert false
		(&Address{})
	}
	assert a2.host == 0x0100A8C0
	assert a2.port == 0
	if _ := new_address('') {
		assert false
	}
	a3 := new_address('example.com') or {
		assert false
		(&Address{})
	}
	assert a3.host != 0x00000000
	assert a3.port == 0
	a4 := new_address('localhost:3000') or {
		assert false
		(&Address{})
	}
	assert a4.host == 0x0100007F
	assert a4.port == 3000
}

fn test_set_host_ip() {
	mut addr := Address{}
	addr.set_host_ip('1.1.1.1') or { assert false }
	assert addr.host == 0x01010101
	addr.set_host_ip('192.168.0.1') or { assert false }
	assert addr.host == 0x0100A8C0
	if _ := addr.set_host_ip('example.com') {
		assert false
	}
	assert addr.host == 0x0100A8C0
	if _ := addr.set_host_ip('') {
		assert false
	}
	assert addr.host == 0x0100A8C0
}

fn test_set_host_name() {
	mut addr := Address{}
	addr.set_host_name('example.com') or { assert false }
	assert addr.host != 0x00000000
	addr.set_host_name('1.1.1.1') or { assert false }
	assert addr.host == 0x01010101
	addr.set_host_name('192.168.0.1') or { assert false }
	assert addr.host == 0x0100A8C0
	addr.set_host_name('localhost') or { assert false }
	assert addr.host == 0x0100007F
}

fn test_get_host_ip() {
	mut addr := Address{}
	addr.set_host_ip('1.1.1.1') or { panic('unexpected error') }
	ip1 := addr.get_host_ip() or {
		assert false
		''
	}
	assert ip1 == '1.1.1.1'
	addr.set_host_name('localhost') or { panic('unexpected error') }
	ip2 := addr.get_host_ip() or {
		assert false
		''
	}
	assert ip2 == '127.0.0.1'
}
