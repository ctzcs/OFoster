package foster_spatial

import "core:math"

RectInt :: struct {
	X, Y: int,
	Width, Height: int,
}

RectIntIdentity :: RectInt{0, 0, 1, 1}

RectIntPosition :: proc(rect: RectInt) -> Point2 { return Point2{rect.X, rect.Y} }
RectIntSize :: proc(rect: RectInt) -> Point2 { return Point2{rect.Width, rect.Height} }
RectIntArea :: proc(rect: RectInt) -> int { return rect.Width * rect.Height }
RectIntLeft :: proc(rect: RectInt) -> int { return rect.X }
RectIntRight :: proc(rect: RectInt) -> int { return rect.X + rect.Width }
RectIntTop :: proc(rect: RectInt) -> int { return rect.Y }
RectIntBottom :: proc(rect: RectInt) -> int { return rect.Y + rect.Height }
RectIntCenter :: proc(rect: RectInt) -> Point2 { return Point2{rect.X + rect.Width/2, rect.Y + rect.Height/2} }
RectIntCenterX :: proc(rect: RectInt) -> int { return rect.X + rect.Width/2 }
RectIntCenterY :: proc(rect: RectInt) -> int { return rect.Y + rect.Height/2 }
RectIntMin :: proc(rect: RectInt) -> Point2 { return Point2{math.min(RectIntLeft(rect),RectIntRight(rect)), math.min(RectIntTop(rect),RectIntBottom(rect))} }
RectIntMax :: proc(rect: RectInt) -> Point2 { return Point2{math.max(RectIntLeft(rect),RectIntRight(rect)), math.max(RectIntTop(rect),RectIntBottom(rect))} }
RectIntTopLeft :: proc(rect: RectInt) -> Point2 { return Point2{RectIntLeft(rect), RectIntTop(rect)} }
RectIntTopCenter :: proc(rect: RectInt) -> Point2 { return Point2{RectIntCenterX(rect), RectIntTop(rect)} }
RectIntTopRight :: proc(rect: RectInt) -> Point2 { return Point2{RectIntRight(rect), RectIntTop(rect)} }
RectIntCenterLeft :: proc(rect: RectInt) -> Point2 { return Point2{RectIntLeft(rect), RectIntCenterY(rect)} }
RectIntCenterPoint :: proc(rect: RectInt) -> Point2 { return RectIntCenter(rect) }
RectIntCenterRight :: proc(rect: RectInt) -> Point2 { return Point2{RectIntRight(rect), RectIntCenterY(rect)} }
RectIntBottomLeft :: proc(rect: RectInt) -> Point2 { return Point2{RectIntLeft(rect), RectIntBottom(rect)} }
RectIntBottomCenter :: proc(rect: RectInt) -> Point2 { return Point2{RectIntCenterX(rect), RectIntBottom(rect)} }
RectIntBottomRight :: proc(rect: RectInt) -> Point2 { return Point2{RectIntRight(rect), RectIntBottom(rect)} }

RectIntCenterXF :: proc(rect: RectInt) -> f32 { return f32(rect.X) + f32(rect.Width)*0.5 }
RectIntCenterYF :: proc(rect: RectInt) -> f32 { return f32(rect.Y) + f32(rect.Height)*0.5 }
RectIntTopCenterF :: proc(rect: RectInt) -> Vec2 { return Vec2{RectIntCenterXF(rect), f32(RectIntTop(rect))} }
RectIntCenterLeftF :: proc(rect: RectInt) -> Vec2 { return Vec2{f32(RectIntLeft(rect)), RectIntCenterYF(rect)} }
RectIntCenterF :: proc(rect: RectInt) -> Vec2 { return Vec2{RectIntCenterXF(rect), RectIntCenterYF(rect)} }
RectIntCenterRightF :: proc(rect: RectInt) -> Vec2 { return Vec2{f32(RectIntRight(rect)), RectIntCenterYF(rect)} }
RectIntBottomCenterF :: proc(rect: RectInt) -> Vec2 { return Vec2{RectIntCenterXF(rect), f32(RectIntBottom(rect))} }

rect_int_contains_point :: proc(rect: RectInt, point: Point2) -> bool {
	return point.X >= rect.X && point.Y >= rect.Y && point.X < RectIntRight(rect) && point.Y < RectIntBottom(rect)
}

RectIntContainsVec2 :: proc(rect: RectInt, point: Vec2) -> bool {
	return point[0] >= f32(rect.X) && point[1] >= f32(rect.Y) && point[0] < f32(RectIntRight(rect)) && point[1] < f32(RectIntBottom(rect))
}

RectIntContains :: proc{rect_int_contains_point, RectIntContainsVec2}

RectIntContainsRect :: proc(rect, other: RectInt) -> bool {
	return RectIntLeft(rect) < RectIntLeft(other) && RectIntTop(rect) < RectIntTop(other) &&
		RectIntRight(rect) > RectIntRight(other) && RectIntBottom(rect) > RectIntBottom(other)
}

rect_int_overlaps_rectint :: proc(rect, other: RectInt) -> bool {
	return RectIntRight(rect) > RectIntLeft(other) && RectIntBottom(rect) > RectIntTop(other) &&
		RectIntLeft(rect) < RectIntRight(other) && RectIntTop(rect) < RectIntBottom(other)
}

RectIntOverlapsRect :: proc(rect: RectInt, other: Rect) -> bool {
	return f32(RectIntRight(rect)) > RectRight(other) && f32(RectIntBottom(rect)) > RectTop(other) &&
		f32(RectIntLeft(rect)) < RectRight(other) && f32(RectIntTop(rect)) < RectBottom(other)
}

RectIntConflatePoint :: proc(rect: RectInt, other: Point2) -> RectInt {
	return RectIntBetween(
		Point2{math.min(RectIntLeft(rect), other.X), math.min(RectIntTop(rect), other.Y)},
		Point2{math.max(RectIntRight(rect), other.X), math.max(RectIntBottom(rect), other.Y)},
	)
}

rect_int_conflate_rect :: proc(rect, other: RectInt) -> RectInt {
	min_x := math.min(RectIntLeft(rect), RectIntLeft(other))
	min_y := math.min(RectIntTop(rect), RectIntTop(other))
	max_x := math.max(RectIntRight(rect), RectIntRight(other))
	max_y := math.max(RectIntBottom(rect), RectIntBottom(other))
	return RectInt{min_x, min_y, max_x-min_x, max_y-min_y}
}
RectIntConflate :: proc{rect_int_conflate_rect, RectIntConflatePoint}

RectIntIntersection :: proc(rect, other: RectInt) -> RectInt {
	left := math.max(RectIntLeft(rect), RectIntLeft(other))
	top := math.max(RectIntTop(rect), RectIntTop(other))
	right := math.min(RectIntRight(rect), RectIntRight(other))
	bottom := math.min(RectIntBottom(rect), RectIntBottom(other))
	if right <= left || bottom <= top do return RectInt{}
	return RectInt{left, top, right-left, bottom-top}
}

RectIntAt :: proc(rect: RectInt, position: Point2) -> RectInt { return RectInt{position.X, position.Y, rect.Width, rect.Height} }
RectIntAtXY :: proc(rect: RectInt, x, y: int) -> RectInt { return RectInt{x, y, rect.Width, rect.Height} }
RectIntAtX :: proc(rect: RectInt, x: int) -> RectInt { return RectInt{x, rect.Y, rect.Width, rect.Height} }
RectIntAtY :: proc(rect: RectInt, y: int) -> RectInt { return RectInt{rect.X, y, rect.Width, rect.Height} }
RectIntTranslate :: proc(rect: RectInt, by: Point2) -> RectInt { return RectInt{rect.X+by.X, rect.Y+by.Y, rect.Width, rect.Height} }
RectIntTranslateXY :: proc(rect: RectInt, x, y: int) -> RectInt { return RectInt{rect.X+x, rect.Y+y, rect.Width, rect.Height} }

rect_int_scale :: proc(rect: RectInt, by: int) -> RectInt {
	return RectIntValidateSize(RectInt{rect.X*by, rect.Y*by, rect.Width*by, rect.Height*by})
}

RectIntScaleXY :: proc(rect: RectInt, by_x, by_y: int) -> RectInt {
	return RectIntValidateSize(RectInt{rect.X*by_x, rect.Y*by_y, rect.Width*by_x, rect.Height*by_y})
}

RectIntScalePoint :: proc(rect: RectInt, by: Point2) -> RectInt {
	return RectIntScaleXY(rect, by.X, by.Y)
}

rect_int_scale_x :: proc(rect: RectInt, by: int) -> RectInt { return RectIntValidateSize(RectInt{rect.X*by, rect.Y, rect.Width*by, rect.Height}) }
rect_int_scale_y :: proc(rect: RectInt, by: int) -> RectInt { return RectIntValidateSize(RectInt{rect.X, rect.Y*by, rect.Width, rect.Height*by}) }
rect_int_scale_float :: proc(rect: RectInt, by: f32) -> Rect {
	return RectValidateSize(Rect{f32(rect.X)*by, f32(rect.Y)*by, f32(rect.Width)*by, f32(rect.Height)*by})
}
RectIntScaleFloatXY :: proc(rect: RectInt, by_x, by_y: f32) -> Rect {
	return RectValidateSize(Rect{f32(rect.X)*by_x, f32(rect.Y)*by_y, f32(rect.Width)*by_x, f32(rect.Height)*by_y})
}
RectIntScaleFloatInt :: proc(rect: RectInt, by_x: f32, by_y: int) -> Rect {
	return RectValidateSize(Rect{f32(rect.X)*by_x, f32(rect.Y)*f32(by_y), f32(rect.Width)*by_x, f32(rect.Height)*f32(by_y)})
}
RectIntScaleIntFloat :: proc(rect: RectInt, by_x: int, by_y: f32) -> Rect {
	return RectValidateSize(Rect{f32(rect.X)*f32(by_x), f32(rect.Y)*by_y, f32(rect.Width)*f32(by_x), f32(rect.Height)*by_y})
}
RectIntScaleVec :: proc(rect: RectInt, by: Vec2) -> Rect { return RectIntScaleFloatXY(rect, by[0], by[1]) }
RectIntScaleXFloat :: proc(rect: RectInt, by: f32) -> Rect { return RectValidateSize(Rect{f32(rect.X)*by, f32(rect.Y), f32(rect.Width)*by, f32(rect.Height)}) }
RectIntScaleYFloat :: proc(rect: RectInt, by: f32) -> Rect { return RectValidateSize(Rect{f32(rect.X), f32(rect.Y)*by, f32(rect.Width), f32(rect.Height)*by}) }
RectIntScaleX :: proc{rect_int_scale_x, RectIntScaleXFloat}
RectIntScaleY :: proc{rect_int_scale_y, RectIntScaleYFloat}
RectIntScale :: proc{rect_int_scale, RectIntScaleXY, RectIntScalePoint, rect_int_scale_float, RectIntScaleFloatXY, RectIntScaleFloatInt, RectIntScaleIntFloat, RectIntScaleVec}

rect_int_inflate :: proc(rect: RectInt, by: int) -> RectInt {
	return RectInt{rect.X-by, rect.Y-by, rect.Width+by*2, rect.Height+by*2}
}

RectIntInflateXY :: proc(rect: RectInt, by_x, by_y: int) -> RectInt { return RectInt{rect.X-by_x, rect.Y-by_y, rect.Width+by_x*2, rect.Height+by_y*2} }
RectIntInflatePoint :: proc(rect: RectInt, by: Point2) -> RectInt { return RectIntInflateXY(rect, by.X, by.Y) }
rect_int_inflate_x :: proc(rect: RectInt, by: int) -> RectInt { return RectInt{rect.X-by, rect.Y, rect.Width+by*2, rect.Height} }
rect_int_inflate_y :: proc(rect: RectInt, by: int) -> RectInt { return RectInt{rect.X, rect.Y-by, rect.Width, rect.Height+by*2} }
RectIntInflateLTRB :: proc(rect: RectInt, left, top, right, bottom: int) -> RectInt { return RectInt{rect.X-left, rect.Y-top, rect.Width+left+right, rect.Height+top+bottom} }
rect_int_inflate_float :: proc(rect: RectInt, by: f32) -> Rect { return Rect{f32(rect.X)-by, f32(rect.Y)-by, f32(rect.Width)+by*2, f32(rect.Height)+by*2} }
RectIntInflateFloatXY :: proc(rect: RectInt, by_x, by_y: f32) -> Rect { return Rect{f32(rect.X)-by_x, f32(rect.Y)-by_y, f32(rect.Width)+by_x*2, f32(rect.Height)+by_y*2} }
RectIntInflateFloatInt :: proc(rect: RectInt, by_x: f32, by_y: int) -> Rect { return Rect{f32(rect.X)-by_x, f32(rect.Y)-f32(by_y), f32(rect.Width)+by_x*2, f32(rect.Height)+f32(by_y)*2} }
RectIntInflateIntFloat :: proc(rect: RectInt, by_x: int, by_y: f32) -> Rect { return Rect{f32(rect.X)-f32(by_x), f32(rect.Y)-by_y, f32(rect.Width)+f32(by_x)*2, f32(rect.Height)+by_y*2} }
RectIntInflateVec :: proc(rect: RectInt, by: Vec2) -> Rect { return RectIntInflateFloatXY(rect, by[0], by[1]) }
RectIntInflateFloatLTRB :: proc(rect: RectInt, left, top, right, bottom: f32) -> Rect { return Rect{f32(rect.X)-left, f32(rect.Y)-top, f32(rect.Width)+left+right, f32(rect.Height)+top+bottom} }
RectIntInflateXFloat :: proc(rect: RectInt, by: f32) -> Rect { return Rect{f32(rect.X)-by, f32(rect.Y), f32(rect.Width)+by*2, f32(rect.Height)} }
RectIntInflateYFloat :: proc(rect: RectInt, by: f32) -> Rect { return Rect{f32(rect.X), f32(rect.Y)-by, f32(rect.Width), f32(rect.Height)+by*2} }
RectIntInflateX :: proc{rect_int_inflate_x, RectIntInflateXFloat}
RectIntInflateY :: proc{rect_int_inflate_y, RectIntInflateYFloat}
RectIntInflate :: proc{rect_int_inflate, RectIntInflateXY, RectIntInflatePoint, RectIntInflateLTRB, rect_int_inflate_float, RectIntInflateFloatXY, RectIntInflateFloatInt, RectIntInflateIntFloat, RectIntInflateVec, RectIntInflateFloatLTRB}

RectIntValidateSize :: proc(rect: RectInt) -> RectInt {
	r := rect
	if r.Width < 0 { r.X += r.Width; r.Width = -r.Width }
	if r.Height < 0 { r.Y += r.Height; r.Height = -r.Height }
	return r
}

RectIntCentered :: proc(center, size: Point2) -> RectInt {
	return RectInt{center.X-size.X/2, center.Y-size.Y/2, size.X, size.Y}
}
RectIntCenteredXY :: proc(cx, cy, width, height: int) -> RectInt { return RectInt{cx-width/2, cy-height/2, width, height} }
RectIntCenteredSize :: proc(size: Point2) -> RectInt { return RectIntCentered(Point2{}, size) }
RectIntJustified :: proc(origin, size: Point2, justify: Vec2) -> RectInt { return RectInt{origin.X-int(math.round(justify[0]*f32(size.X))), origin.Y-int(math.round(justify[1]*f32(size.Y))), size.X, size.Y} }
RectIntJustifiedXY :: proc(origin: Point2, width, height: int, justify_x, justify_y: f32) -> RectInt { return RectIntJustified(origin, Point2{width,height}, Vec2{justify_x,justify_y}) }

RectIntBetween :: proc(a, b: Point2) -> RectInt {
	min_x := math.min(a.X, b.X)
	min_y := math.min(a.Y, b.Y)
	return RectInt{min_x, min_y, math.max(a.X,b.X)-min_x, math.max(a.Y,b.Y)-min_y}
}

RectIntGetPointSector :: proc(rect: RectInt, point: [2]f32) -> u8 {
	sector: u8 = 0
	if point[0] < f32(rect.X) do sector |= 0b0001
	if point[0] >= f32(RectIntRight(rect)) do sector |= 0b0010
	if point[1] < f32(rect.Y) do sector |= 0b0100
	if point[1] >= f32(RectIntBottom(rect)) do sector |= 0b1000
	return sector
}

RectIntEdges :: proc(rect: RectInt) -> [4]LineInt {
	return [4]LineInt{
		LineInt{RectIntTopRight(rect), RectIntBottomRight(rect)},
		LineInt{RectIntBottomRight(rect), RectIntBottomLeft(rect)},
		LineInt{RectIntBottomLeft(rect), RectIntTopLeft(rect)},
		LineInt{RectIntTopLeft(rect), RectIntTopRight(rect)},
	}
}

rect_int_rotate_left_origin :: proc(rect: RectInt, origin: Point2) -> RectInt {
	points := [4]Point2{RectIntTopLeft(rect), RectIntTopRight(rect), RectIntBottomRight(rect), RectIntBottomLeft(rect)}
	min_p := Point2{1<<30, 1<<30}; max_p := Point2{-1<<30, -1<<30}
	for p in points {
		d := Point2{p.X-origin.X, p.Y-origin.Y}; q := Point2{d.Y, -d.X}
		min_p = Point2{math.min(min_p.X, q.X), math.min(min_p.Y, q.Y)}
		max_p = Point2{math.max(max_p.X, q.X), math.max(max_p.Y, q.Y)}
	}
	return RectInt{min_p.X, min_p.Y, max_p.X-min_p.X, max_p.Y-min_p.Y}
}

rect_int_rotate_right_origin :: proc(rect: RectInt, origin: Point2) -> RectInt {
	points := [4]Point2{RectIntTopLeft(rect), RectIntTopRight(rect), RectIntBottomRight(rect), RectIntBottomLeft(rect)}
	min_p := Point2{1<<30, 1<<30}; max_p := Point2{-1<<30, -1<<30}
	for p in points {
		d := Point2{p.X-origin.X, p.Y-origin.Y}; q := Point2{-d.Y, d.X}
		min_p = Point2{math.min(min_p.X, q.X), math.min(min_p.Y, q.Y)}
		max_p = Point2{math.max(max_p.X, q.X), math.max(max_p.Y, q.Y)}
	}
	return RectInt{min_p.X, min_p.Y, max_p.X-min_p.X, max_p.Y-min_p.Y}
}

rect_int_rotate_left :: proc(rect: RectInt) -> RectInt { return rect_int_rotate_left_origin(rect, Point2Zero) }
rect_int_rotate_left_count :: proc(rect: RectInt, count: int) -> RectInt { r := rect; for i := 0; i < count; i += 1 { r = rect_int_rotate_left_origin(r, Point2Zero) }; return r }
rect_int_rotate_left_origin_count :: proc(rect: RectInt, origin: Point2, count: int) -> RectInt { r := rect; for i := 0; i < count; i += 1 { r = rect_int_rotate_left_origin(r, origin) }; return r }
rect_int_rotate_right :: proc(rect: RectInt) -> RectInt { return rect_int_rotate_right_origin(rect, Point2Zero) }
rect_int_rotate_right_count :: proc(rect: RectInt, count: int) -> RectInt { r := rect; for i := 0; i < count; i += 1 { r = rect_int_rotate_right_origin(r, Point2Zero) }; return r }
rect_int_rotate_right_origin_count :: proc(rect: RectInt, origin: Point2, count: int) -> RectInt { r := rect; for i := 0; i < count; i += 1 { r = rect_int_rotate_right_origin(r, origin) }; return r }
RectIntRotateLeft :: proc{rect_int_rotate_left, rect_int_rotate_left_origin, rect_int_rotate_left_count, rect_int_rotate_left_origin_count}
RectIntRotateRight :: proc{rect_int_rotate_right, rect_int_rotate_right_origin, rect_int_rotate_right_count, rect_int_rotate_right_origin_count}
RectIntRotate :: proc(rect: RectInt, direction: Cardinal) -> RectInt { return rect_int_rotate_right_count(rect, direction.Value) }
RectIntGetSweep :: proc(rect: RectInt, direction: Cardinal, distance: int) -> RectInt {
	d := distance
	c := direction
	if d < 0 { d = -d; c = CardinalReverse(c) }
	switch c.Value {
	case CardinalRightValue: return RectInt{rect.X+rect.Width, rect.Y, d, rect.Height}
	case CardinalLeftValue: return RectInt{rect.X-d, rect.Y, d, rect.Height}
	case CardinalDownValue: return RectInt{rect.X, rect.Y+rect.Height, rect.Width, d}
	case: return RectInt{rect.X, rect.Y-d, rect.Width, d}
	}
}

RectIntGetPoint :: proc(rect: RectInt, index: int) -> [2]f32 {
	switch index { case 0: return [2]f32{f32(rect.X), f32(rect.Y)}; case 1: return [2]f32{f32(RectIntRight(rect)), f32(rect.Y)}; case 2: return [2]f32{f32(RectIntRight(rect)), f32(RectIntBottom(rect))}; case 3: return [2]f32{f32(rect.X), f32(RectIntBottom(rect))} }
	panic("RectInt point index out of range")
}
RectIntGetAxis :: proc(rect: RectInt, index: int) -> [2]f32 { if index == 0 do return [2]f32{1, 0}; if index == 1 do return [2]f32{0, 1}; panic("RectInt axis index out of range") }
RectIntPoints :: proc(rect: RectInt) -> int { return 4 }
RectIntAxes :: proc(rect: RectInt) -> int { return 2 }

RectIntEnumeratePoints :: proc(rect: RectInt) -> [dynamic]Point2 {
	points: [dynamic]Point2
	if rect.Width <= 0 || rect.Height <= 0 do return points
	reserve(&points, rect.Width*rect.Height)
	for y := 0; y < rect.Height; y += 1 {
		for x := 0; x < rect.Width; x += 1 { append(&points, Point2{rect.X+x, rect.Y+y}) }
	}
	return points
}

RectIntEnumerateEdges :: proc(rect: RectInt) -> [4]LineInt { return RectIntEdges(rect) }

RectIntOverlapsLine :: proc(rect: RectInt, line: Line) -> bool {
	sec_a := RectIntGetPointSector(rect, line.From)
	sec_b := RectIntGetPointSector(rect, line.To)
	if sec_a == 0 || sec_b == 0 do return true
	if (sec_a & sec_b) != 0 do return false
	for edge in RectIntEdges(rect) {
		edge_line := Line{Vec2{f32(edge.From.X), f32(edge.From.Y)}, Vec2{f32(edge.To.X), f32(edge.To.Y)}}
		if hit, _ := LineIntersects(edge_line, line); hit do return true
	}
	return false
}

RectIntOverlapsLineInt :: proc(rect: RectInt, line: LineInt) -> bool {
	sec_a := RectIntGetPointSector(rect, [2]f32{f32(line.From.X), f32(line.From.Y)})
	sec_b := RectIntGetPointSector(rect, [2]f32{f32(line.To.X), f32(line.To.Y)})
	if sec_a == 0 || sec_b == 0 do return true
	if (sec_a & sec_b) != 0 do return false
	for edge in RectIntEdges(rect) { if LineIntIntersects(edge, line) do return true }
	return false
}

RectIntOverlaps :: proc{rect_int_overlaps_rectint, RectIntOverlapsRect, RectIntOverlapsLine, RectIntOverlapsLineInt}
