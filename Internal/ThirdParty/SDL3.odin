package foster_internal_thirdparty

// Foster's internal SDL declarations map directly to Odin's maintained SDL3
// vendor package.  These aliases keep the original namespace available while
// ensuring callers use the same ABI and constants as the runtime.
import SDL "vendor:sdl3"

SDLBool :: bool
SDLAssertState :: SDL.AssertState
SDLAssertData :: SDL.AssertData
SDLEvent :: SDL.Event
SDLWindow :: SDL.Window
SDLGPUDevice :: SDL.GPUDevice
SDLGPUTexture :: SDL.GPUTexture
SDLGPUBuffer :: SDL.GPUBuffer
SDLVersion :: struct { Major, Minor, Patch: int }
SDLGetVersion :: proc() -> SDLVersion { v:=SDL.GetVersion(); return SDLVersion{int(SDL.VERSIONNUM_MAJOR(v)),int(SDL.VERSIONNUM_MINOR(v)),int(SDL.VERSIONNUM_MICRO(v))} }
