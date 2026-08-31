package foster_spatial

import "core:math"

Cardinal :: struct { Value: int }
CardinalRightValue :: 0
CardinalDownValue :: 1
CardinalLeftValue :: 2
CardinalUpValue :: 3
CardinalRight :: Cardinal{CardinalRightValue}
CardinalDown :: Cardinal{CardinalDownValue}
CardinalLeft :: Cardinal{CardinalLeftValue}
CardinalUp :: Cardinal{CardinalUpValue}
CardinalEast :: CardinalRight
CardinalSouth :: CardinalDown
CardinalWest :: CardinalLeft
CardinalNorth :: CardinalUp

CardinalMake :: proc(value: int) -> Cardinal { return Cardinal{((value % 4) + 4) % 4} }
CardinalReverse :: proc(c: Cardinal) -> Cardinal { return CardinalMake(c.Value + 2) }
CardinalTurnRight :: proc(c: Cardinal) -> Cardinal { return CardinalMake(c.Value + 1) }
CardinalTurnLeft :: proc(c: Cardinal) -> Cardinal { return CardinalMake(c.Value + 3) }
CardinalHorizontal :: proc(c: Cardinal) -> bool { return c.Value % 2 == 0 }
CardinalVertical :: proc(c: Cardinal) -> bool { return c.Value % 2 == 1 }
CardinalX :: proc(c: Cardinal) -> int { if c == CardinalRight do return 1; if c == CardinalLeft do return -1; return 0 }
CardinalY :: proc(c: Cardinal) -> int { if c == CardinalDown do return 1; if c == CardinalUp do return -1; return 0 }
CardinalPoint :: proc(c: Cardinal) -> Point2 { return Point2{CardinalX(c), CardinalY(c)} }
CardinalAngle :: proc(c: Cardinal) -> f32 { switch c.Value { case 0: return 0; case 1: return f32(math.PI/2); case 2: return f32(math.PI); case 3: return -f32(math.PI/2) }; return 0 }
CardinalAbs :: proc(c: Cardinal) -> Cardinal { if CardinalHorizontal(c) do return CardinalRight; return CardinalDown }
CardinalFromPoint :: proc(p: Point2) -> Cardinal { if math.abs(p.X) > math.abs(p.Y) { if p.X < 0 do return CardinalLeft; return CardinalRight }; if p.Y < 0 do return CardinalUp; return CardinalDown }
CardinalFromVector :: proc(v: [2]f32) -> Cardinal { if math.abs(v[0]) > math.abs(v[1]) { if v[0] < 0 do return CardinalLeft; return CardinalRight }; if v[1] < 0 do return CardinalUp; return CardinalDown }
CardinalAll :: [4]Cardinal{CardinalRight, CardinalDown, CardinalLeft, CardinalUp}
