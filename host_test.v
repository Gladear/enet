module enet

fn test_new_server() {
	mut server := new_server({}) or {
		assert false
		return
	}
	unsafe { server.free() }
}

fn test_new_client() {
	mut client := new_client({}) or {
		assert false
		return
	}
	unsafe { client.free() }
}

// FIXME F*ck tests, what are they there for after all ?
/*
fn serve_test_connect(addr &Address) {
	mut server := new_server(
		addr: addr
		peer_count: 2
	) or { panic('unexpected error') }
	for {
		event := server.service(300) or {
			eprintln('$err $errcode')
			assert false
			return
		}
		match event.@type {
			.connect, .receive {
				eprintln('unexpected event type `${event.@type}`')
			}
			.disconnect {
				println('received `.disconnect`')
				break
			}
		}
	}
	unsafe { server.free() }
}

fn test_connect() {
	addr := new_address('localhost:9000') or { panic('unexpected error') }
	go serve_test_connect(addr)
	mut client := new_client({}) or { panic('unexpected error') }
	mut peer := client.connect(addr: addr) or {
		assert false
		return
	}
	for {
		event := client.service(300) or {
			eprintln('$err $errcode')
			assert false
			return
		}
		match event.@type {
			.connect {
				peer.disconnect(0)
			}
			.receive {
				panic('unexpected `.receive` event')
			}
			.disconnect {
				break
			}
		}
	}
}
*/

// XXX A timeout is hard to test, given that we can't configure it, and
// there is no builtin V server to check for a failure to my knowledge
/*
fn test_connect_no_server() {

	addr := new_address('localhost:8080') or { panic('unexpected error') }
	mut client := new_client({}) or { panic('unexpected error') }

	client.connect(addr: addr) or {
		assert false
		return
	}
	event := client.service(2000) or {
		assert false
		return
	}
	assert event.@type == .disconnect
}
*/
