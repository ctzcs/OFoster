package foster_graphics_structs

import runtime "../.."
import spatial "../../Spatial"
import "core:math"

CoordinateBuffer :: [4]spatial.Vec2

Subtexture :: struct {
	Texture:    ^runtime.Texture,
	Source:     spatial.Rect,
	Frame:      spatial.Rect,
	TexCoords:  CoordinateBuffer,
	DrawCoords: CoordinateBuffer,
}

SubtextureEmpty :: Subtexture{}

SubtextureMake :: proc(texture: ^runtime.Texture, source, frame: spatial.Rect) -> Subtexture {
	result := Subtexture{Texture = texture, Source = source, Frame = frame}
	result.DrawCoords = CoordinateBuffer{
		{-frame.X, -frame.Y}, {-frame.X+source.Width, -frame.Y},
		{-frame.X+source.Width, -frame.Y+source.Height}, {-frame.X, -frame.Y+source.Height},
	}
	if texture != nil && texture.Width > 0 && texture.Height > 0 {
		px := 1.0/f32(texture.Width); py := 1.0/f32(texture.Height)
		tx0 := source.X*px; ty0 := source.Y*py
		tx1 := spatial.RectRight(source)*px; ty1 := spatial.RectBottom(source)*py
		result.TexCoords = CoordinateBuffer{{tx0,ty0},{tx1,ty0},{tx1,ty1},{tx0,ty1}}
	}
	return result
}

SubtextureFromTexture :: proc(texture: ^runtime.Texture) -> Subtexture {
	if texture == nil do return Subtexture{}
	bounds := spatial.Rect{0, 0, f32(texture.Width), f32(texture.Height)}
	return SubtextureMake(texture, bounds, bounds)
}

SubtextureFromSource :: proc(texture: ^runtime.Texture, source: spatial.Rect) -> Subtexture {
	return SubtextureMake(texture, source, spatial.Rect{0, 0, source.Width, source.Height})
}

SubtextureWidth :: proc(subtexture: Subtexture) -> f32 { return subtexture.Frame.Width }
SubtextureHeight :: proc(subtexture: Subtexture) -> f32 { return subtexture.Frame.Height }
SubtextureSize :: proc(subtexture: Subtexture) -> spatial.Vec2 { return spatial.RectSize(subtexture.Frame) }
SubtextureIsEmpty :: proc(subtexture: Subtexture) -> bool { return subtexture.Texture == nil || subtexture.Source.Width == 0 || subtexture.Source.Height == 0 }

SubtextureGetClip :: proc(subtexture: Subtexture, clip: spatial.Rect) -> (source, frame: spatial.Rect) {
	source_position := spatial.RectPosition(subtexture.Source)
	frame_position := spatial.RectPosition(subtexture.Frame)
	offset := spatial.Vec2{source_position[0]+frame_position[0], source_position[1]+frame_position[1]}
	source = spatial.RectIntersection(spatial.RectTranslate(clip, offset), subtexture.Source)
	frame = spatial.Rect{math.min(f32(0), subtexture.Frame.X+clip.X), math.min(f32(0), subtexture.Frame.Y+clip.Y), clip.Width, clip.Height}
	return
}

SubtextureGetClipSubtexture :: proc(subtexture: Subtexture, clip: spatial.Rect) -> Subtexture {
	source, frame := SubtextureGetClip(subtexture, clip)
	return SubtextureMake(subtexture.Texture, source, frame)
}
