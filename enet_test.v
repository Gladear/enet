module enet

fn test_version_consts() {
	assert version_major == C.ENET_VERSION_MAJOR
	assert version_minor == C.ENET_VERSION_MINOR
	assert version_patch == C.ENET_VERSION_PATCH
	assert (version >> 16) == version_major
	assert (version >> 8) & 0xff == version_minor
	assert (version >> 0) & 0xff == version_patch
}
