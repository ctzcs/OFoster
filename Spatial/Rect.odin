package foster_spatial

import "core:math"

Rect :: struct {
	X, Y: f32,
	Width, Height: f32,
}

RectIdentity :: Rect{0, 0, 1, 1}
RectPosition :: proc(rect: Rect) -> Vec2 { return Vec2{rect.X, rect.Y} }
RectSize :: proc(rect: Rect) -> Vec2 { return Vec2{rect.Width, rect.Height} }
RectArea :: proc(rect: Rect) -> f32 { return math.abs(rect.Width*rect.Height) }
RectLeft :: proc(rect: Rect) -> f32 { return rect.X }
RectRight :: proc(rect: Rect) -> f32 { return rect.X+rect.Width }
RectTop :: proc(rect: Rect) -> f32 { return rect.Y }
RectBottom :: proc(rect: Rect) -> f32 { return rect.Y+rect.Height }
RectCenter :: proc(rect: Rect) -> Vec2 { return Vec2{rect.X+rect.Width*0.5, rect.Y+rect.Height*0.5} }
RectCenterX :: proc(rect: Rect) -> f32 { return rect.X + rect.Width*0.5 }
RectCenterY :: proc(rect: Rect) -> f32 { return rect.Y + rect.Height*0.5 }
RectMin :: proc(rect: Rect) -> Vec2 { return Vec2{math.min(RectLeft(rect),RectRight(rect)), math.min(RectTop(rect),RectBottom(rect))} }
RectMax :: proc(rect: Rect) -> Vec2 { return Vec2{math.max(RectLeft(rect),RectRight(rect)), math.max(RectTop(rect),RectBottom(rect))} }
RectTopLeft :: proc(rect: Rect) -> Vec2 { return Vec2{RectLeft(rect), RectTop(rect)} }
RectTopCenter :: proc(rect: Rect) -> Vec2 { return Vec2{RectCenterX(rect), RectTop(rect)} }
RectTopRight :: proc(rect: Rect) -> Vec2 { return Vec2{RectRight(rect), RectTop(rect)} }
RectCenterLeft :: proc(rect: Rect) -> Vec2 { return Vec2{RectLeft(rect), RectCenterY(rect)} }
RectCenterRight :: proc(rect: Rect) -> Vec2 { return Vec2{RectRight(rect), RectCenterY(rect)} }
RectBottomLeft :: proc(rect: Rect) -> Vec2 { return Vec2{RectLeft(rect), RectBottom(rect)} }
RectBottomCenter :: proc(rect: Rect) -> Vec2 { return Vec2{RectCenterX(rect), RectBottom(rect)} }
RectBottomRight :: proc(rect: Rect) -> Vec2 { return Vec2{RectRight(rect), RectBottom(rect)} }
RectOn :: proc(rect: Rect, x, y: f32) -> Vec2 { return Vec2{rect.X+rect.Width*x, rect.Y+rect.Height*y} }
RectOnVec :: proc(rect: Rect, vec: Vec2) -> Vec2 { return RectOn(rect, vec[0], vec[1]) }

RectContains :: proc(rect: Rect, point: Vec2) -> bool {
	return point[0] >= rect.X && point[1] >= rect.Y && point[0] < RectRight(rect) && point[1] < RectBottom(rect)
}
RectContainsRect :: proc(rect, other: Rect) -> bool {
	return RectLeft(rect) <= RectLeft(other) && RectTop(rect) <= RectTop(other) && RectRight(rect) >= RectRight(other) && RectBottom(rect) >= RectBottom(other)
}
RectOverlaps :: proc(rect, other: Rect) -> bool {
	return RectRight(rect) > RectLeft(other) && RectBottom(rect) > RectTop(other) && RectLeft(rect) < RectRight(other) && RectTop(rect) < RectBottom(other)
}
RectIntersection :: proc(rect, other: Rect) -> Rect {
	left := math.max(RectLeft(rect), RectLeft(other)); top := math.max(RectTop(rect), RectTop(other))
	right := math.min(RectRight(rect), RectRight(other)); bottom := math.min(RectBottom(rect), RectBottom(other))
	if right <= left || bottom <= top do return Rect{}
	return Rect{left, top, right-left, bottom-top}
}

RectDifference :: proc(rect, other: Rect) -> [dynamic]Rect {
	result: [dynamic]Rect
	r := RectValidateSize(rect)
	o := RectValidateSize(other)
	i := RectIntersection(r, o)
	if i.Width <= 0 || i.Height <= 0 { append(&result, r); return result }
	if i.Y > r.Y { append(&result, Rect{r.X, r.Y, r.Width, i.Y-r.Y}) }
	if RectBottom(i) < RectBottom(r) { append(&result, Rect{r.X, RectBottom(i), r.Width, RectBottom(r)-RectBottom(i)}) }
	if i.X > r.X { append(&result, Rect{r.X, i.Y, i.X-r.X, i.Height}) }
	if RectRight(i) < RectRight(r) { append(&result, Rect{RectRight(i), i.Y, RectRight(r)-RectRight(i), i.Height}) }
	return result
}

RectGetPointSector :: proc(rect: Rect, point: Vec2) -> u8 {
	sector: u8 = 0
	if point[0] < rect.X { sector |= 0b0001 } else if point[0] >= RectRight(rect) { sector |= 0b0010 }
	if point[1] < rect.Y { sector |= 0b0100 } else if point[1] >= RectBottom(rect) { sector |= 0b1000 }
	return sector
}

RectClosestPoint :: proc(rect: Rect, point: Vec2) -> Vec2 {
	return Vec2{math.clamp(point[0], RectLeft(rect), RectRight(rect)), math.clamp(point[1], RectTop(rect), RectBottom(rect))}
}

RectEdges :: proc(rect: Rect) -> [4]Line {
	return [4]Line{
		Line{RectTopRight(rect), RectBottomRight(rect)}, Line{RectBottomRight(rect), RectBottomLeft(rect)},
		Line{RectBottomLeft(rect), RectTopLeft(rect)}, Line{RectTopLeft(rect), RectTopRight(rect)},
	}
}

RectOverlapsLine :: proc(rect: Rect, line: Line) -> (bool, Vec2) {
	if RectContains(rect, line.From) do return true, line.From
	if RectContains(rect, line.To) do return true, line.To
	for edge in RectEdges(rect) { hit, point := LineIntersects(edge, line); if hit do return true, point }
	return false, Vec2{}
}
RectOverlapsTriangle :: proc(rect: Rect, tri: Triangle) -> bool {
	if TriangleContains(tri, RectTopLeft(rect)) { return true }
	hit, _ := RectOverlapsLine(rect, TriangleAB(tri)); if hit { return true }
	hit, _ = RectOverlapsLine(rect, TriangleBC(tri)); if hit { return true }
	hit, _ = RectOverlapsLine(rect, TriangleCA(tri)); return hit
}

RectIntValue :: proc(rect: Rect) -> RectInt { return RectInt{int(rect.X), int(rect.Y), int(rect.Width), int(rect.Height)} }
rect_at_vec :: proc(rect: Rect, position: Vec2) -> Rect { return Rect{position[0], position[1], rect.Width, rect.Height} }
RectAtXY :: proc(rect: Rect, x, y: f32) -> Rect { return Rect{x, y, rect.Width, rect.Height} }
RectAtX :: proc(rect: Rect, x: f32) -> Rect { return Rect{x, rect.Y, rect.Width, rect.Height} }
RectAtY :: proc(rect: Rect, y: f32) -> Rect { return Rect{rect.X, y, rect.Width, rect.Height} }
RectAt :: proc{rect_at_vec, RectAtXY}
RectTranslate :: proc(rect: Rect, by: Vec2) -> Rect { return Rect{rect.X+by[0], rect.Y+by[1], rect.Width, rect.Height} }
RectTranslateXY :: proc(rect: Rect, x, y: f32) -> Rect { return Rect{rect.X+x, rect.Y+y, rect.Width, rect.Height} }
rect_inflate :: proc(rect: Rect, by: f32) -> Rect { return Rect{rect.X-by, rect.Y-by, rect.Width+by*2, rect.Height+by*2} }
RectInflateXY :: proc(rect: Rect, by_x, by_y: f32) -> Rect { return Rect{rect.X-by_x, rect.Y-by_y, rect.Width+by_x*2, rect.Height+by_y*2} }
RectInflateX :: proc(rect: Rect, by_x: f32) -> Rect { return Rect{rect.X-by_x, rect.Y, rect.Width+by_x*2, rect.Height} }
RectInflateY :: proc(rect: Rect, by_y: f32) -> Rect { return Rect{rect.X, rect.Y-by_y, rect.Width, rect.Height+by_y*2} }
RectInflateLTRB :: proc(rect: Rect, left, top, right, bottom: f32) -> Rect { return Rect{rect.X-left, rect.Y-top, rect.Width+left+right, rect.Height+top+bottom} }
RectInflate :: proc{rect_inflate, RectInflateXY, RectInflateLTRB}
rect_scale :: proc(rect: Rect, by: f32) -> Rect { return RectValidateSize(Rect{rect.X*by, rect.Y*by, rect.Width*by, rect.Height*by}) }
RectScaleXY :: proc(rect: Rect, by_x, by_y: f32) -> Rect { return RectValidateSize(Rect{rect.X*by_x, rect.Y*by_y, rect.Width*by_x, rect.Height*by_y}) }
RectScaleVec :: proc(rect: Rect, by: Vec2) -> Rect { return RectScaleXY(rect, by[0], by[1]) }
RectScaleX :: proc(rect: Rect, by_x: f32) -> Rect { return RectValidateSize(Rect{rect.X*by_x, rect.Y, rect.Width*by_x, rect.Height}) }
RectScaleY :: proc(rect: Rect, by_y: f32) -> Rect { return RectValidateSize(Rect{rect.X, rect.Y*by_y, rect.Width, rect.Height*by_y}) }
RectScale :: proc{rect_scale, RectScaleXY, RectScaleVec}
RectValidateSize :: proc(rect: Rect) -> Rect { r := rect; if r.Width < 0 { r.X += r.Width; r.Width = -r.Width }; if r.Height < 0 { r.Y += r.Height; r.Height = -r.Height }; return r }
RectConflate :: proc(rect, other: Rect) -> Rect { return RectBetween(Vec2{math.min(RectLeft(rect),RectLeft(other)), math.min(RectTop(rect),RectTop(other))}, Vec2{math.max(RectRight(rect),RectRight(other)), math.max(RectBottom(rect),RectBottom(other))}) }

RectProject :: proc(rect: Rect, axis: Vec2) -> (min, max: f32) {
	points := [4]Vec2{RectTopLeft(rect), RectTopRight(rect), RectBottomRight(rect), RectBottomLeft(rect)}
	min = 1e30; max = -1e30
	for point in points { dot := vec2_dot(point, axis); min = math.min(min, dot); max = math.max(max, dot) }
	return
}

RectCentered :: proc(center, size: Vec2) -> Rect { return Rect{center[0]-size[0]*0.5, center[1]-size[1]*0.5, size[0], size[1]} }
RectCenteredXY :: proc(cx, cy, width, height: f32) -> Rect { return Rect{cx-width*0.5, cy-height*0.5, width, height} }
RectCenteredSize :: proc(size: Vec2) -> Rect { return RectCentered(Vec2{}, size) }
RectJustifiedOrigin :: proc(origin, size, justify: Vec2) -> Rect { return Rect{origin[0]-size[0]*justify[0], origin[1]-size[1]*justify[1], size[0], size[1]} }
RectJustifiedXY :: proc(origin: Vec2, width, height, justify_x, justify_y: f32) -> Rect { return RectJustifiedOrigin(origin, Vec2{width,height}, Vec2{justify_x,justify_y}) }
RectJustifiedSize :: proc(width, height, justify_x, justify_y: f32) -> Rect { return RectJustifiedXY(Vec2{}, width, height, justify_x, justify_y) }
RectJustified :: proc{RectJustifiedOrigin, RectJustifiedXY, RectJustifiedSize}
RectJustifiedAt :: proc(rect: Rect, pos, justify: Vec2) -> Rect { return Rect{pos[0]-rect.Width*justify[0], pos[1]-rect.Height*justify[1], rect.Width, rect.Height} }
RectBetween :: proc(a, b: Vec2) -> Rect { min_x := math.min(a[0],b[0]); min_y := math.min(a[1],b[1]); return Rect{min_x,min_y,math.max(a[0],b[0])-min_x,math.max(a[1],b[1])-min_y} }

RectTransform :: proc(rect: Rect, m: Matrix3x2) -> Quad {
	return Quad{Matrix3x2TransformPoint(m, RectTopLeft(rect)), Matrix3x2TransformPoint(m, RectTopRight(rect)), Matrix3x2TransformPoint(m, RectBottomRight(rect)), Matrix3x2TransformPoint(m, RectBottomLeft(rect))}
}

RectGetPoint :: proc(rect: Rect, index: int) -> Vec2 {
	switch index { case 0: return RectTopLeft(rect); case 1: return RectTopRight(rect); case 2: return RectBottomRight(rect); case 3: return RectBottomLeft(rect) }
	return Vec2{}
}
RectGetAxis :: proc(rect: Rect, index: int) -> Vec2 { if index == 0 do return Vec2{1, 0}; if index == 1 do return Vec2{0, 1}; return Vec2{} }
