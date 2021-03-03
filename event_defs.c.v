module enet

struct C._ENetEvent {
pub:
	@type     EventType
	peer      &C._ENetPeer
	channelID byte
	data      u32
	packet    &C._ENetPacket
}
