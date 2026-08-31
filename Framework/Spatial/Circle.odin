package foster_spatial

import "core:math"

Circle :: struct {
	Position: Vec2,
	Radius:   f32,
}

CircleMake :: proc(position: Vec2, radius: f32) -> Circle { return Circle{Position = position, Radius = radius} }
CircleArea :: proc(circle: Circle) -> f32 { return f32(math.PI)*circle.Radius*circle.Radius }
CircleCircumference :: proc(circle: Circle) -> f32 { return f32(math.TAU)*circle.Radius }
CircleBounds :: proc(circle: Circle) -> Rect { diameter := circle.Radius*2; return RectCentered(circle.Position, Vec2{diameter, diameter}) }
CircleContains :: proc(circle: Circle, point: Vec2) -> bool { return vec2_length_squared(vec2_sub(circle.Position, point)) < circle.Radius*circle.Radius }

circle_overlaps_circle :: proc(circle, other: Circle) -> (overlaps: bool, pushout: Vec2) {
	combined := circle.Radius + other.Radius
	delta := vec2_sub(circle.Position, other.Position)
	distance_squared := vec2_length_squared(delta)
	if distance_squared >= combined*combined do return false, Vec2{}
	distance := math.sqrt(distance_squared)
	if distance <= 0 do return true, Vec2{combined, 0}
	return true, vec2_scale(delta, (combined-distance)/distance)
}

CircleOverlapsCenter :: proc(circle: Circle, center: Vec2, radius: f32) -> bool { delta := vec2_sub(circle.Position, center); combined := circle.Radius + radius; return vec2_length_squared(delta) < combined*combined }
CircleOverlaps :: proc{circle_overlaps_circle, CircleOverlapsCenter}

CircleOverlapsLine :: proc(circle: Circle, line: Line) -> bool {
	return LineDistanceSquared(line, circle.Position) < circle.Radius*circle.Radius
}

CircleProject :: proc(circle: Circle, axis: Vec2) -> (min, max: f32) {
	unit := vec2_normalized(axis)
	center := vec2_dot(circle.Position, unit)
	return center-circle.Radius, center+circle.Radius
}

CircleAt :: proc(circle: Circle, position: Vec2) -> Circle { return Circle{position, circle.Radius} }
CircleAtXY :: proc(circle: Circle, x, y: f32) -> Circle { return Circle{Vec2{x, y}, circle.Radius} }
CircleInflate :: proc(circle: Circle, amount: f32) -> Circle { return Circle{circle.Position, circle.Radius+amount} }
CircleTranslate :: proc(circle: Circle, by: Vec2) -> Circle { return Circle{vec2_add(circle.Position, by), circle.Radius} }
CircleIntersectsLine :: proc(circle: Circle, line: Line) -> bool { return CircleOverlapsLine(circle, line) }
