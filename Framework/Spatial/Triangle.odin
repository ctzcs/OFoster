package foster_spatial

import "core:math"

Triangle :: struct { A, B, C: Vec2 }
TriangleMake :: proc(a, b, c: Vec2) -> Triangle { return Triangle{a, b, c} }
TriangleAB :: proc(t: Triangle) -> Line { return Line{t.A, t.B} }
TriangleBC :: proc(t: Triangle) -> Line { return Line{t.B, t.C} }
TriangleCA :: proc(t: Triangle) -> Line { return Line{t.C, t.A} }
TriangleArea :: proc(t: Triangle) -> f32 { return math.abs((t.A[0]*(t.B[1]-t.C[1]) + t.B[0]*(t.C[1]-t.A[1]) + t.C[0]*(t.A[1]-t.B[1]))*0.5) }
TriangleBounds :: proc(t: Triangle) -> Rect { return RectBetween(Vec2{math.min(t.A[0],math.min(t.B[0],t.C[0])), math.min(t.A[1],math.min(t.B[1],t.C[1]))}, Vec2{math.max(t.A[0],math.max(t.B[0],t.C[0])), math.max(t.A[1],math.max(t.B[1],t.C[1]))}) }
TriangleCenter :: proc(t: Triangle) -> Vec2 { return RectCenter(TriangleBounds(t)) }
TriangleAverage :: proc(t: Triangle) -> Vec2 { return vec2_scale(vec2_add(vec2_add(t.A,t.B),t.C), 1.0/3.0) }
triangle_cross :: proc(a, b: Vec2) -> f32 { return a[0]*b[1]-a[1]*b[0] }
TriangleContains :: proc(t: Triangle, point: Vec2) -> bool {
	d0 := triangle_cross(vec2_sub(t.B,t.A), vec2_sub(point,t.A)); d1 := triangle_cross(vec2_sub(t.C,t.B), vec2_sub(point,t.B)); d2 := triangle_cross(vec2_sub(t.A,t.C), vec2_sub(point,t.C))
	return (d0 >= 0 && d1 >= 0 && d2 >= 0) || (d0 <= 0 && d1 <= 0 && d2 <= 0)
}
TriangleProject :: proc(t: Triangle, axis: Vec2) -> (min, max: f32) { a:=vec2_dot(t.A,axis); b:=vec2_dot(t.B,axis); c:=vec2_dot(t.C,axis); return math.min(a,math.min(b,c)), math.max(a,math.max(b,c)) }
