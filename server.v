module enet

import time

const (
	service_timeout = 1 * time.second
)

pub interface Server {
	enet_host &Host
	on_connect(peer &Peer)
	on_disconnect(peer &Peer)
	on_receive(event &Event)
}

pub fn serve(s &Server) ? {
	for {
		event := s.enet_host.service(u32(service_timeout)) ?
		match event.@type {
			.none_ {}
			.connect {
				s.on_connect(event.peer)
			}
			.disconnect {
				s.on_disconnect(event.peer)
			}
			.receive {
				s.on_receive(event)
			}
		}
	}
}
