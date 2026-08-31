package foster_framework

import "core:fmt"
import SDL "vendor:sdl3"

// Keep the port's public version aligned with the upstream Foster package.
FosterVersionMajor :: 0
FosterVersionMinor :: 3
FosterVersionPatch :: 0

version_string :: proc() -> string {
	return fmt.aprintf("%d.%d.%d", FosterVersionMajor, FosterVersionMinor, FosterVersionPatch)
}

sdl_version_string :: proc() -> string {
	v := SDL.GetVersion()
	return fmt.aprintf("%d.%d.%d", SDL.VERSIONNUM_MAJOR(v), SDL.VERSIONNUM_MINOR(v), SDL.VERSIONNUM_MICRO(v))
}
