module enet

struct C._ENetCompressor {
pub:
	context    voidptr
	compress   fn (voidptr, C.ENetBuffer, size_t, size_t, byte, size_t) size_t
	decompress fn (voidptr, byte, size_t, byte, size_t)
	destroy    fn (voidptr)
}
