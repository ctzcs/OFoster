package foster_internal

import SDL "vendor:sdl3"

GraphicsDeviceSDLReady :: proc() -> bool {
	return SDL.GetVersion() != 0
}
