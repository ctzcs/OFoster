package foster_spatial

import "core:math"

LineInt :: struct {
	From: Point2,
	To:   Point2,
}

LineIntMake :: proc(from, to: Point2) -> LineInt {
	return LineInt{From = from, To = to}
}

LineIntPoints :: proc(line: LineInt) -> int { return 2 }
LineIntAxes :: proc(line: LineInt) -> int { return 1 }

LineIntBounds :: proc(line: LineInt) -> RectInt {
	return RectIntBetween(line.From, line.To)
}

LineIntGetAxis :: proc(line: LineInt, index: int) -> [2]f32 {
	if index != 0 do return [2]f32{}
	dx := f32(line.To.X - line.From.X)
	dy := f32(line.To.Y - line.From.Y)
	length := math.sqrt(dx*dx + dy*dy)
	if length == 0 do return [2]f32{}
	return [2]f32{dy / length, -dx / length}
}

LineIntGetPoint :: proc(line: LineInt, index: int) -> Point2 {
	switch index {
	case 0: return line.From
	case 1: return line.To
	}
	return Point2{}
}

LineIntProject :: proc(line: LineInt, axis: [2]f32) -> (min, max: f32) {
	min = 1e30
	max = -1e30
	points := [2]Point2{line.From, line.To}
	for p in points {
		dot := f32(p.X)*axis[0] + f32(p.Y)*axis[1]
		min = math.min(min, dot)
		max = math.max(max, dot)
	}
	return
}

LineIntIntersects :: proc(a, b: LineInt) -> bool {
	bx := f32(a.To.X - a.From.X)
	by := f32(a.To.Y - a.From.Y)
	dx := f32(b.To.X - b.From.X)
	dy := f32(b.To.Y - b.From.Y)
	denom := bx*dy - by*dx
	if denom == 0 do return false
	cx := f32(b.From.X - a.From.X)
	cy := f32(b.From.Y - a.From.Y)
	t := (cx*dy - cy*dx) / denom
	u := (cx*by - cy*bx) / denom
	return t >= 0 && t <= 1 && u >= 0 && u <= 1
}

LineIntTranslate :: proc(line: LineInt, by: Point2) -> LineInt {
	return LineInt{
		From = Point2{line.From.X + by.X, line.From.Y + by.Y},
		To = Point2{line.To.X + by.X, line.To.Y + by.Y},
	}
}
