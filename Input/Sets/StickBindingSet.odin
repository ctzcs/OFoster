package foster_input_sets

import runtime "../.."
import bindings "../Bindings"
import enums "../Enums"

StickEntry :: struct { Left, Right, Up, Down: bindings.Binding, CircularDeadzone: f32, Overlap: bindings.BindingAxisOverlap, Masks: [dynamic]string }
StickBindingSet :: struct { Entries: [dynamic]StickEntry }
StickBindingSetAdd :: proc(set: ^StickBindingSet, left, right, up, down: bindings.Binding, deadzone := f32(0), overlap := bindings.BindingAxisOverlap.TakeNewer, masks: ..string) {
	e := StickEntry{Left=left, Right=right, Up=up, Down=down, CircularDeadzone=deadzone, Overlap=overlap}; for m in masks { append(&e.Masks, m) }; append(&set.Entries, e)
}
StickBindingSetAddKeys :: proc(set: ^StickBindingSet, left, right, up, down: enums.Keys, overlap := bindings.BindingAxisOverlap.TakeNewer, masks: ..string) { StickBindingSetAdd(set, bindings.Binding{Kind=.KeyboardKey, Key=left}, bindings.Binding{Kind=.KeyboardKey, Key=right}, bindings.Binding{Kind=.KeyboardKey, Key=up}, bindings.Binding{Kind=.KeyboardKey, Key=down}, 0, overlap, ..masks[:]) }
StickBindingSetAddButtons :: proc(set: ^StickBindingSet, left, right, up, down: enums.Buttons, overlap := bindings.BindingAxisOverlap.TakeNewer, masks: ..string) { StickBindingSetAdd(set, bindings.Binding{Kind=.ControllerButton, Button=left}, bindings.Binding{Kind=.ControllerButton, Button=right}, bindings.Binding{Kind=.ControllerButton, Button=up}, bindings.Binding{Kind=.ControllerButton, Button=down}, 0, overlap, ..masks[:]) }
StickBindingSetAddAxes :: proc(set: ^StickBindingSet, x, y: enums.Axes, deadzone: f32, overlap := bindings.BindingAxisOverlap.TakeNewer, masks: ..string) { StickBindingSetAdd(set, bindings.Binding{Kind=.ControllerAxis, Axis=x, Sign=-1}, bindings.Binding{Kind=.ControllerAxis, Axis=x, Sign=1}, bindings.Binding{Kind=.ControllerAxis, Axis=y, Sign=-1}, bindings.Binding{Kind=.ControllerAxis, Axis=y, Sign=1}, deadzone, overlap, ..masks[:]) }
StickBindingSetValue :: proc(set: ^StickBindingSet, input: ^runtime.Input, device: int) -> [2]f32 {
	value: [2]f32 = {}
	for e in set.Entries { l := bindings.BindingGetState(e.Left,input,device); r := bindings.BindingGetState(e.Right,input,device); u := bindings.BindingGetState(e.Up,input,device); d := bindings.BindingGetState(e.Down,input,device); next := [2]f32{bindings.BindingAxisOverlapResolve(e.Overlap,l,r), bindings.BindingAxisOverlapResolve(e.Overlap,u,d)}; if e.CircularDeadzone > 0 && next[0]*next[0]+next[1]*next[1] < e.CircularDeadzone*e.CircularDeadzone { continue }; if next[0]*next[0]+next[1]*next[1] > value[0]*value[0]+value[1]*value[1] { value = next } }
	return value
}
StickBindingSetClear :: proc(set: ^StickBindingSet) { clear(&set.Entries) }
StickBindingSet_StickEntry :: StickEntry

