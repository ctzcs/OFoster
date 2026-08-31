package foster_spatial

import "core:math"

Quad :: struct { A, B, C, D: Vec2 }
QuadMake :: proc(a, b, c, d: Vec2) -> Quad { return Quad{a,b,c,d} }
QuadFromRect :: proc(rect: Rect) -> Quad { return Quad{RectTopLeft(rect),RectTopRight(rect),RectBottomRight(rect),RectBottomLeft(rect)} }
QuadBounds :: proc(q: Quad) -> Rect {
	min := Vec2{math.min(q.A[0],math.min(q.B[0],math.min(q.C[0],q.D[0]))), math.min(q.A[1],math.min(q.B[1],math.min(q.C[1],q.D[1])))}
	max := Vec2{math.max(q.A[0],math.max(q.B[0],math.max(q.C[0],q.D[0]))), math.max(q.A[1],math.max(q.B[1],math.max(q.C[1],q.D[1])))}
	return RectBetween(min,max)
}
QuadCenter :: proc(q: Quad) -> Vec2 { return RectCenter(QuadBounds(q)) }
QuadAverage :: proc(q: Quad) -> Vec2 { return vec2_scale(vec2_add(vec2_add(q.A,q.B),vec2_add(q.C,q.D)),0.25) }
QuadEdges :: proc(q: Quad) -> [4]Line { return [4]Line{Line{q.A,q.B},Line{q.B,q.C},Line{q.C,q.D},Line{q.D,q.A}} }
QuadProject :: proc(q: Quad, axis: Vec2) -> (min,max:f32) { points:=[4]Vec2{q.A,q.B,q.C,q.D}; min=1e30;max=-1e30;for p in points { d:=vec2_dot(p,axis);min=math.min(min,d);max=math.max(max,d)};return }
