package foster_input_bindings

import "core:time"

BindingState :: struct { Pressed, Released, Down: bool, Value: f32, Timestamp: time.Duration }
