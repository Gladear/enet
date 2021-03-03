module enet

#flag -I @VROOT/enet/include
#flag -L @VROOT/enet/.libs -lenet
#flag -Wl,-rpath -Wl,@VROOT/enet/.libs

#include <enet/enet.h> # Please clone the repository with `--recurse-submodules`

pub const (
	version_major = byte(C.ENET_VERSION_MAJOR)
	version_minor = byte(C.ENET_VERSION_MINOR)
	version_patch = byte(C.ENET_VERSION_PATCH)
	version       = u32(C.ENET_VERSION)
)

[inline]
fn init() {
	errcode := C.enet_initialize()
	if errcode != 0 {
		panic('unable to initialize ENet')
	}
	C.atexit(C.enet_deinitialize)
}
