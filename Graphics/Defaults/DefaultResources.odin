package foster_graphics_defaults

import runtime "../.."

DefaultResources :: runtime.DefaultResources
DefaultResourcesInit :: runtime.DefaultResourcesInit
DefaultResourcesDispose :: runtime.DefaultResourcesDispose
DefaultResourcesAvailable :: proc(device:^runtime.GraphicsDevice) -> bool {
	return device != nil && device.Defaults.Initialized
}
