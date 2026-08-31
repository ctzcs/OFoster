package foster_utility

import "core:math"

Linear :: proc(t: f32) -> f32 { return t }
InQuad :: proc(t: f32) -> f32 { return t*t }
OutQuad :: proc(t: f32) -> f32 { return t*(2-t) }
InOutQuad :: proc(t: f32) -> f32 { if t < 0.5 do return 2*t*t; return -1+(4-2*t)*t }
SineIn :: proc(t: f32) -> f32 { return 1-math.cos(t*f32(math.PI)*0.5) }
SineOut :: proc(t: f32) -> f32 { return math.sin(t*f32(math.PI)*0.5) }
SineInOut :: proc(t: f32) -> f32 { return -(math.cos(f32(math.PI)*t)-1)*0.5 }
