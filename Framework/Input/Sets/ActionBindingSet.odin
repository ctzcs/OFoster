package foster_input_sets

import runtime "../.."
import bindings "../Bindings"
import enums "../Enums"

ActionEntry :: struct { Binding: bindings.Binding, Masks: [dynamic]string }
ActionBindingSet :: struct { Entries: [dynamic]ActionEntry }
ActionBindingSetMake :: proc() -> ActionBindingSet { return ActionBindingSet{} }
ActionBindingSetAdd :: proc(set: ^ActionBindingSet, binding: bindings.Binding, masks: ..string) {
	e := ActionEntry{Binding=binding}; for m in masks { append(&e.Masks, m) }; append(&set.Entries, e)
}
ActionBindingSetAddKey :: proc(set: ^ActionBindingSet, key: enums.Keys, masks: ..string) { ActionBindingSetAdd(set, bindings.Binding{Kind=.KeyboardKey, Key=key}, ..masks[:]) }
ActionBindingSetAddButton :: proc(set: ^ActionBindingSet, button: enums.Buttons, masks: ..string) { ActionBindingSetAdd(set, bindings.Binding{Kind=.ControllerButton, Button=button}, ..masks[:]) }
ActionBindingSetAddMouseButton :: proc(set: ^ActionBindingSet, button: enums.MouseButtons, masks: ..string) { ActionBindingSetAdd(set, bindings.Binding{Kind=.MouseButton, MouseButton=button}, ..masks[:]) }
ActionBindingSetAddAxis :: proc(set: ^ActionBindingSet, axis: enums.Axes, sign: int, deadzone := f32(0), masks: ..string) { ActionBindingSetAdd(set, bindings.Binding{Kind=.ControllerAxis, Axis=axis, Sign=sign, Deadzone=deadzone}, ..masks[:]) }
ActionBindingSetGetState :: proc(set: ^ActionBindingSet, input: ^runtime.Input, device: int) -> bindings.BindingState {
	r := bindings.BindingState{}
	for e in set.Entries { s := bindings.BindingGetState(e.Binding, input, device); r.Pressed |= s.Pressed; r.Released |= s.Released; r.Down |= s.Down; if s.Value > r.Value { r.Value = s.Value }; if s.Timestamp > r.Timestamp { r.Timestamp = s.Timestamp } }
	return r
}
ActionBindingSetClear :: proc(set: ^ActionBindingSet) { clear(&set.Entries) }
ActionBindingSet_ActionEntry :: ActionEntry

