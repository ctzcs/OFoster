package foster_input_bindings

import enums "../Enums"

MouseButtonBinding :: struct { Button: enums.MouseButtons }
MouseButtonBindingMake :: proc(button: enums.MouseButtons) -> MouseButtonBinding { return MouseButtonBinding{button} }
