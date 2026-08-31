package foster_input_sets

import "core:math"
import runtime "../.."
import bindings "../Bindings"
import enums "../Enums"

AxisEntry :: struct { Negative, Positive: bindings.Binding, Overlap: bindings.BindingAxisOverlap, Masks: [dynamic]string }
AxisBindingSet :: struct { Entries: [dynamic]AxisEntry }
AxisBindingSetAdd :: proc(set: ^AxisBindingSet, negative, positive: bindings.Binding, overlap := bindings.BindingAxisOverlap.TakeNewer, masks: ..string) {
	e := AxisEntry{Negative=negative, Positive=positive, Overlap=overlap}; for m in masks { append(&e.Masks, m) }; append(&set.Entries, e)
}
AxisBindingSetAddKeys :: proc(set: ^AxisBindingSet, negative, positive: enums.Keys, overlap := bindings.BindingAxisOverlap.TakeNewer, masks: ..string) { AxisBindingSetAdd(set, bindings.Binding{Kind=.KeyboardKey, Key=negative}, bindings.Binding{Kind=.KeyboardKey, Key=positive}, overlap, ..masks[:]) }
AxisBindingSetAddButtons :: proc(set: ^AxisBindingSet, negative, positive: enums.Buttons, overlap := bindings.BindingAxisOverlap.TakeNewer, masks: ..string) { AxisBindingSetAdd(set, bindings.Binding{Kind=.ControllerButton, Button=negative}, bindings.Binding{Kind=.ControllerButton, Button=positive}, overlap, ..masks[:]) }
AxisBindingSetAddAxis :: proc(set: ^AxisBindingSet, axis: enums.Axes, overlap := bindings.BindingAxisOverlap.TakeNewer, masks: ..string) { AxisBindingSetAdd(set, bindings.Binding{Kind=.ControllerAxis, Axis=axis, Sign=-1}, bindings.Binding{Kind=.ControllerAxis, Axis=axis, Sign=1}, overlap, ..masks[:]) }
AxisBindingSetValue :: proc(set: ^AxisBindingSet, input: ^runtime.Input, device: int) -> f32 {
	value: f32 = 0
	for e in set.Entries { n := bindings.BindingGetState(e.Negative, input, device); p := bindings.BindingGetState(e.Positive, input, device); v := bindings.BindingAxisOverlapResolve(e.Overlap, n, p); if math.abs(v) > math.abs(value) { value = v } }
	return value
}
AxisBindingSetPressedSign :: proc(set: ^AxisBindingSet, input: ^runtime.Input, device: int) -> int { return int(math.sign(AxisBindingSetValue(set, input, device))) }
AxisBindingSetClear :: proc(set: ^AxisBindingSet) { clear(&set.Entries) }
AxisBindingSet_AxisEntry :: AxisEntry

