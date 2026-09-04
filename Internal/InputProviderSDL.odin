package foster_internal

import SDL "vendor:sdl3"

InputProviderSDLReady :: proc() -> bool {
	return SDL.GetVersion() != 0
}
