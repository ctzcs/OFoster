package foster_input_virtual

import "core:time"
import runtime "../.."
import sets "../Sets"

VirtualAction :: struct {
	Base: VirtualInput,
	Set: sets.ActionBindingSet,
	RepeatDelay: f32,
	RepeatInterval: f32,
	Buffer: f32,
	Pressed, PressConsumed, Down, Released, Repeated: bool,
	Value, ValueNoDeadzone: f32,
	Timestamp: time.Duration,
}

VirtualActionMake :: proc(input: ^runtime.Input, name: string, set := sets.ActionBindingSet{}, controller_index := 0, buffer := f32(0)) -> VirtualAction {
	return VirtualAction{Base=VirtualInputMake(input,name,controller_index), Set=set, RepeatDelay=runtime.RepeatDelay, RepeatInterval=runtime.RepeatInterval, Buffer=buffer}
}
VirtualActionUpdate :: proc(v: ^VirtualAction, t: runtime.Time) {
	if v.Base.IsDisposed || v.Base.Input == nil { return }
	s := sets.ActionBindingSetGetState(&v.Set, v.Base.Input, v.Base.ControllerIndex)
	v.Pressed, v.Released, v.Down, v.Value = s.Pressed, s.Released, s.Down, s.Value
	v.ValueNoDeadzone = s.Value
	v.Repeated = false
	if v.Pressed { v.PressConsumed = false; v.Timestamp = t.Elapsed } else if !v.PressConsumed && v.Timestamp > 0 && time.duration_seconds(t.Elapsed-v.Timestamp) < f64(v.Buffer) { v.Pressed = true }
	if v.Down && time.duration_seconds(t.Elapsed-v.Timestamp) > f64(v.RepeatDelay) && v.RepeatInterval > 0 {
		elapsed := time.duration_seconds(t.Elapsed-v.Timestamp) - f64(v.RepeatDelay)
		previous := elapsed - f64(t.Delta)
		v.Repeated = int(previous/f64(v.RepeatInterval)) < int(elapsed/f64(v.RepeatInterval))
	}
}
VirtualActionConsumePress :: proc(v: ^VirtualAction) -> bool { if v.Pressed { v.Pressed=false; v.PressConsumed=true; return true }; return false }
VirtualActionClear :: proc(v: ^VirtualAction) { v.Pressed=false; v.Released=false; v.PressConsumed=true; v.Down=false; v.Repeated=false; v.Value=0; v.ValueNoDeadzone=0 }
VirtualActionSetControllerIndex :: proc(v: ^VirtualAction, index: int) { VirtualInputSetControllerIndex(&v.Base,index) }
