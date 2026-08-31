package foster_input_bindings

import runtime "../.."

BindingAxisOverlap :: enum { TakeNewer, TakeOlder, CancelOut }

BindingAxisOverlapResolve :: proc(overlap: BindingAxisOverlap, negative, positive: BindingState) -> f32 {
    if overlap == .CancelOut do return runtime.Clamp(positive.Value - negative.Value, -1, 1)
    if positive.Down && negative.Down {
        if overlap == .TakeNewer { if negative.Timestamp > positive.Timestamp do return -negative.Value; return positive.Value }
        if negative.Timestamp < positive.Timestamp do return -negative.Value; return positive.Value
    }
    if positive.Down do return positive.Value
    if negative.Down do return -negative.Value
    return 0
}
