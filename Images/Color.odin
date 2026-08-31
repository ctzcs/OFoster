// Color lives in the framework root package; this file preserves Foster's
// original Images/Color.cs import location.
package foster_images

import runtime ".."

Color            :: runtime.Color
Transparent      :: runtime.Transparent
Black            :: runtime.Black
White            :: runtime.White
Red              :: runtime.Red
Green            :: runtime.Green
Blue             :: runtime.Blue
ColorRGB         :: runtime.color_rgb
ColorRGBA        :: runtime.color_rgba_u32
ColorF32         :: runtime.color_f32
RGBA             :: runtime.RGBA
ABGR             :: runtime.ABGR
Premultiply      :: runtime.Premultiply
ColorToVector4   :: runtime.ColorToVector4
ToHexStringRGB   :: runtime.ToHexStringRGB
ToHexStringRGBA  :: runtime.ToHexStringRGBA
FromHexStringRGB :: runtime.FromHexStringRGB
FromHexStringRGBA :: runtime.FromHexStringRGBA
ColorFromHSV     :: runtime.ColorFromHSV
ColorLerp        :: runtime.ColorLerp
