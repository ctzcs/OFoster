package foster_spatial

import "core:math"

Vec2 :: [2]f32

vec2_add :: proc(a, b: Vec2) -> Vec2 { return Vec2{a[0]+b[0], a[1]+b[1]} }
vec2_sub :: proc(a, b: Vec2) -> Vec2 { return Vec2{a[0]-b[0], a[1]-b[1]} }
vec2_scale :: proc(v: Vec2, scalar: f32) -> Vec2 { return Vec2{v[0]*scalar, v[1]*scalar} }
vec2_dot :: proc(a, b: Vec2) -> f32 { return a[0]*b[0] + a[1]*b[1] }
vec2_length_squared :: proc(v: Vec2) -> f32 { return vec2_dot(v, v) }
vec2_length :: proc(v: Vec2) -> f32 { return math.sqrt(vec2_length_squared(v)) }
vec2_normalized :: proc(v: Vec2) -> Vec2 { length := vec2_length(v); if length == 0 do return Vec2{}; return vec2_scale(v, 1/length) }
vec2_lerp :: proc(a, b: Vec2, t: f32) -> Vec2 { return vec2_add(a, vec2_scale(vec2_sub(b, a), t)) }
clamp01 :: proc(value: f32) -> f32 { return math.clamp(value, 0, 1) }

Line :: struct {
	From: Vec2,
	To:   Vec2,
}

LineMakeVec :: proc(from, to: Vec2) -> Line { return Line{From = from, To = to} }
LineMakeXY :: proc(x1, y1, x2, y2: f32) -> Line { return Line{From = Vec2{x1, y1}, To = Vec2{x2, y2}} }
LineMake :: proc{LineMakeVec, LineMakeXY}
LineCenter :: proc(line: Line) -> Vec2 { return vec2_scale(vec2_add(line.From, line.To), 0.5) }
LineLengthSquared :: proc(line: Line) -> f32 { return vec2_length_squared(vec2_sub(line.To, line.From)) }
LineLength :: proc(line: Line) -> f32 { return math.sqrt(LineLengthSquared(line)) }
LineNormal :: proc(line: Line) -> Vec2 { return vec2_normalized(vec2_sub(line.To, line.From)) }
LineBounds :: proc(line: Line) -> Rect { return RectBetween(line.From, line.To) }
LineGetAxis :: proc(line: Line, index: int) -> Vec2 { if index < 0 || index >= 1 do panic("Line axis index out of range"); normal := LineNormal(line); return Vec2{normal[1], -normal[0]} }
LineGetPoint :: proc(line: Line, index: int) -> Vec2 { if index == 0 do return line.From; if index == 1 do return line.To; panic("Line point index out of range") }
LineOn :: proc(line: Line, percent: f32) -> Vec2 { return vec2_lerp(line.From, line.To, percent) }
LineOnClamped :: proc(line: Line, percent: f32) -> Vec2 { return LineOn(line, clamp01(percent)) }

LineProject :: proc(line: Line, axis: Vec2) -> (min, max: f32) {
	a := vec2_dot(line.From, axis)
	b := vec2_dot(line.To, axis)
	return math.min(a, b), math.max(a, b)
}

LineClosestTUnclamped :: proc(line: Line, point: Vec2) -> f32 {
	delta := vec2_sub(line.To, line.From)
	denominator := vec2_length_squared(delta)
	if denominator == 0 do return 0
	return vec2_dot(vec2_sub(point, line.From), delta) / denominator
}

LineClosestT :: proc(line: Line, point: Vec2) -> f32 { return clamp01(LineClosestTUnclamped(line, point)) }
LineClosestPoint :: proc(line: Line, point: Vec2) -> Vec2 { return LineOn(line, LineClosestT(line, point)) }
LineDistanceSquared :: proc(line: Line, point: Vec2) -> f32 { return vec2_length_squared(vec2_sub(LineClosestPoint(line, point), point)) }
LineDistance :: proc(line: Line, point: Vec2) -> f32 { return math.sqrt(LineDistanceSquared(line, point)) }

LineClosestPoints :: proc(line, other: Line) -> (Vec2, Vec2) {
	v1 := vec2_sub(line.To, line.From); v2 := vec2_sub(other.To, other.From); w := vec2_sub(line.From, other.From)
	a := vec2_dot(v1, v1); b := vec2_dot(v1, v2); c := vec2_dot(v2, v2); d := vec2_dot(v1, w); e := vec2_dot(v2, w)
	denom := a*c - b*b
	s: f32 = 0; t: f32 = 0
	if denom < 1e-8 {
		if c > 0 do t = clamp01(e/c)
	} else {
		s = clamp01((b*e-c*d)/denom); t = clamp01((a*e-b*d)/denom)
	}
	return LineOn(line, s), LineOn(other, t)
}
LineClosestDistance :: proc(line, other: Line) -> f32 { a,b := LineClosestPoints(line, other); return vec2_length(vec2_sub(a,b)) }
LineClosestDistanceSquared :: proc(line, other: Line) -> f32 { a,b := LineClosestPoints(line, other); return vec2_length_squared(vec2_sub(a,b)) }
LinePoints :: proc(line: Line) -> int { return 2 }
LineAxes :: proc(line: Line) -> int { return 1 }

LineIntersects :: proc(a, b: Line) -> (hit: bool, point: Vec2) {
	ab := vec2_sub(a.To, a.From)
	bd := vec2_sub(b.To, b.From)
	denom := ab[0]*bd[1] - ab[1]*bd[0]
	if denom == 0 do return false, Vec2{}
	c := vec2_sub(b.From, a.From)
	t := (c[0]*bd[1] - c[1]*bd[0]) / denom
	u := (c[0]*ab[1] - c[1]*ab[0]) / denom
	if t < 0 || t > 1 || u < 0 || u > 1 do return false, Vec2{}
	return true, vec2_add(a.From, vec2_scale(ab, t))
}

LineIntersectsRect :: proc(line: Line, rect: Rect) -> (bool, Vec2) { return RectOverlapsLine(rect, line) }
LineIntersectsCircle :: proc(line: Line, circle: Circle) -> bool { return CircleOverlapsLine(circle, line) }

LineIntersectsBool :: proc(a, b: Line) -> bool { hit, _ := LineIntersects(a, b); return hit }

LineTranslate :: proc(line: Line, by: Vec2) -> Line { return Line{vec2_add(line.From, by), vec2_add(line.To, by)} }
