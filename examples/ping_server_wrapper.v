import gladear.enet

fn main() {
	port := u16(9000)
	server := enet.new_server(port: port) ?
	println('starting server on port $port')
	for {
		event := server.service(1000) or { break }
		match event.@type {
			.none_ {}
			.connect {
				println('new connection: $event.peer().connectID')
			}
			.disconnect {
				println(' disconnection: $event.peer().connectID')
			}
			.receive {
				mut peer := event.peer()
				peer.send(event.channelID, event.packet) or {
					eprintln('error while sending packet back: $err')
					peer.disconnect(0)
				}
			}
		}
	}
	println('server is shuting down...')
}
