import gladear.enet

struct Server {
	enet_host &enet.Host
}

fn (s &Server) on_connect(peer &enet.Peer) {
	println('new connection: $peer.connectID')
}

fn (s &Server) on_disconnect(peer &enet.Peer) {
	println('new connection: $peer.connectID')
}

fn (s &Server) on_receive(event &enet.Event) {
	mut peer := event.peer()
	peer.send(event.channelID, event.packet) or {
		eprintln('error while sending packet back: $err')
		peer.disconnect(0)
	}
}

port := u16(9000)
server := Server{
	enet_host: enet.new_server(port: port) ?
}
println('starting server on port $port')
enet.serve(server) ?
println('server is shuting down...')
