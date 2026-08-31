package foster_input_bindings

MouseMotionBinding :: struct { Axis: [2]f32, Sign: int, Min, Max: f32 }
MouseMotionBindingMake :: proc(axis: [2]f32, sign: int, min_value, max_value: f32) -> MouseMotionBinding { return MouseMotionBinding{axis, sign, min_value, max_value} }
