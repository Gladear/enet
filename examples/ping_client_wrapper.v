import gladear.enet
import time

fn send_pings(mut peer enet.Peer) ? {
	for i := 0; i < 10; i++ {
		packet := enet.new_packet([byte(i)].repeat(i), .reliable)
		peer.send(0, packet) ?
		time.sleep(time.second)
	}
}

fn main() {
	mut client := enet.new_client(1, 2, 0, 0) ?
	addr := enet.new_address('localhost:9000') ?
	mut peer := client.connect(addr, 1, 0) ?
	println('starting ping client...')
	for {
		event := client.service(10000) or { break }
		match event.@type {
			.none_ {
				println('no event received... please open the ping server')
				break
			}
			.connect {
				println('connected, starting to send pings')
				go send_pings(mut peer)
			}
			.disconnect {
				println('disconnected')
				break
			}
			.receive {
				data := event.packet().data()
				println('received: $data')
			}
		}
	}
	println('quitting ping client...')
}
