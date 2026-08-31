package foster_input_bindings

import enums "../Enums"

ControllerButtonBinding :: struct { Button: enums.Buttons }
ControllerButtonBindingMake :: proc(button: enums.Buttons) -> ControllerButtonBinding { return ControllerButtonBinding{button} }
