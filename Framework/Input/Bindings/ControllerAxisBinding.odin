package foster_input_bindings

import enums "../Enums"

ControllerAxisBinding :: struct { Axis: enums.Axes, Sign: int, Deadzone: f32 }
ControllerAxisBindingMake :: proc(axis: enums.Axes, sign: int, deadzone: f32) -> ControllerAxisBinding { return ControllerAxisBinding{axis, sign, deadzone} }
