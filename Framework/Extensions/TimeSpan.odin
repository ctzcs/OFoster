package foster_extensions

import "core:math"
import coretime "core:time"

DurationModulo :: proc(value: coretime.Duration, seconds:f64)->coretime.Duration{if seconds<=0{return 0}; period:=coretime.Duration(seconds*1e9); return value%period}
DurationLerp :: proc(value:coretime.Duration,seconds:f64)->f32{if seconds<=0{return 0};return f32(coretime.duration_seconds(DurationModulo(value,seconds)) / seconds)}
DurationYoyo :: proc(value:coretime.Duration,seconds:f64)->f32{t:=DurationLerp(value,seconds)*2;if t>1{return f32(2-t)};return f32(t)}
DurationSin :: proc(value:coretime.Duration,rate:=f64(1),offset:=f64(0))->f32{return f32(math.sin(coretime.duration_seconds(value)*rate+offset))}
DurationCos :: proc(value:coretime.Duration,rate:=f64(1),offset:=f64(0))->f32{return f32(math.cos(coretime.duration_seconds(value)*rate+offset))}
