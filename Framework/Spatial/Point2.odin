// Point2 is implemented by the framework root package. Re-exporting it here
// keeps Foster's original per-file import layout available to Odin callers.
package foster_spatial
import runtime ".."

Point2             :: runtime.Point2
Point2Zero         :: runtime.Point2Zero
Point2One          :: runtime.Point2One
Point2UnitX        :: runtime.Point2UnitX
Point2UnitY        :: runtime.Point2UnitY
Point2Right        :: runtime.Point2Right
Point2Left         :: runtime.Point2Left
Point2Up           :: runtime.Point2Up
Point2Down         :: runtime.Point2Down
Point2Length       :: runtime.Point2Length
Point2LengthSquared :: runtime.Point2LengthSquared
Point2Vector2      :: runtime.Point2Vector2
Point2Normalized   :: runtime.Point2Normalized
Point2GetLengthAndNormalize :: runtime.Point2GetLengthAndNormalize
Point2Add          :: runtime.Point2Add
Point2Sub          :: runtime.Point2Sub
Point2Negate       :: runtime.Point2Negate
Point2Scale        :: runtime.Point2Scale
Point2Div          :: runtime.Point2Div
Point2Mod          :: runtime.Point2Mod
Point2FloorTo      :: runtime.Point2FloorTo
Point2RoundTo      :: runtime.Point2RoundTo
Point2OnlyX        :: runtime.Point2OnlyX
Point2OnlyY        :: runtime.Point2OnlyY
Point2TurnRight    :: runtime.Point2TurnRight
Point2TurnLeft     :: runtime.Point2TurnLeft
Point2Sign         :: runtime.Point2Sign
Point2Abs          :: runtime.Point2Abs
Point2Clamp        :: runtime.Point2Clamp
Point2ManhattanDist :: runtime.Point2ManhattanDist
Point2Min          :: runtime.Point2Min
Point2Max          :: runtime.Point2Max
Point2FromBools    :: runtime.Point2FromBools
