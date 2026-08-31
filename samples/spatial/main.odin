package main

import "core:fmt"
import spatial "../../Framework/Spatial"
import images "../../Framework/Images"
import graphics_enums "../../Framework/Graphics/Enums"
import graphics "../../Framework/Graphics"
import graphics_structs "../../Framework/Graphics/Structs"
import input_enums "../../Framework/Input/Enums"
import input "../../Framework/Input"
import storage "../../Framework/Storage"
import utility "../../Framework/Utility"
import bindings "../../Framework/Input/Bindings"
import defaults "../../Framework/Graphics/Defaults"
import interfaces "../../Framework/Graphics/Interfaces"
import virtual "../../Framework/Input/Virtual"
import input_sets "../../Framework/Input/Sets"
import utility_ext "../../Framework/Extensions"
import internal "../../Framework/Internal"
import thirdparty "../../Framework/Internal/ThirdParty"

main :: proc() {
	p := spatial.Point2{3, 4}
	fmt.println("point length:", spatial.Point2Length(p))
	r := spatial.RectInt{0, 0, 10, 10}
	fmt.println("contains:", spatial.RectIntContains(r, spatial.Point2{4, 4}))
	fmt.println("intersection area:", spatial.RectIntArea(spatial.RectIntIntersection(r, spatial.RectInt{5, 5, 10, 10})))
	fmt.println("line intersection:", spatial.LineIntIntersects(spatial.LineIntMake(spatial.Point2{0, 0}, spatial.Point2{10, 10}), spatial.LineIntMake(spatial.Point2{0, 10}, spatial.Point2{10, 0})))
	fmt.println("cardinal point:", spatial.CardinalPoint(spatial.CardinalLeft))
	float_rect := spatial.Rect{0, 0, 10, 10}
	line_hit, line_point := spatial.RectOverlapsLine(float_rect, spatial.LineMake(spatial.Vec2{-2, 5}, spatial.Vec2{12, 5}))
	fmt.println("rect/line:", line_hit, line_point)
	circle_hit, pushout := spatial.CircleOverlaps(spatial.CircleMake(spatial.Vec2{0, 0}, 5), spatial.CircleMake(spatial.Vec2{8, 0}, 5))
	fmt.println("circle overlap:", circle_hit, pushout)
	transform := spatial.TransformMake(spatial.Vec2{10, 20}, spatial.Vec2{2, 2}, 0)
	transformed := spatial.TransformPoint(&transform, spatial.Vec2{1, 1})
	fmt.println("transform:", transformed, spatial.TransformPointInverse(&transform, transformed))
	fmt.println("red rgba:", images.RGBA(images.Red), "format size:", graphics_enums.TextureFormatSize(.Color), "key:", input_enums.Keys.A)
	_ = input.KeyboardState{}
	_ = input.MouseState{}
	_ = input.ControllerState{}
	_ = storage.StorageContainer{}
	fmt.println("ease:", utility.InOutQuad(0.25), "clamp:", utility.Clamp01(1.5))
	_ = bindings.BindingAxisOverlapResolve(.CancelOut, bindings.BindingState{}, bindings.BindingState{})
	_ = defaults.BatcherVertex{}
	_ = interfaces.VertexData{}
	_ = graphics.Texture{}
	_ = graphics_structs.VertexFormat{}
	fake_texture := graphics.Texture{Width = 64, Height = 32}
	subtexture := graphics_structs.SubtextureFromSource(&fake_texture, spatial.Rect{16, 8, 32, 16})
	fmt.println("tex coords:", subtexture.TexCoords[0], subtexture.TexCoords[2])
	polygon := spatial.PolygonMake(spatial.Vec2{0, 0}, spatial.Vec2{10, 0}, spatial.Vec2{10, 10}, spatial.Vec2{0, 10})
	fmt.println("polygon:", spatial.PolygonContains(polygon, spatial.Vec2{5, 5}), spatial.PolygonArea(&polygon), len(polygon.Indices))
	rng := utility.RngMake(123)
	fmt.println("rng:", utility.RngIntMax(&rng, 10), utility.RngChance(&rng, 1))
	action_set := input_sets.ActionBindingSetMake()
	input_sets.ActionBindingSetAddKey(&action_set, input_enums.Keys.Space)
	input_state := input.Input{}
	action := virtual.VirtualActionMake(&input_state, "jump", action_set)
	virtual.VirtualActionUpdate(&action, utility.Time{})
	fmt.println("virtual action:", action.Value, utility_ext.EnumHas(3, 1), internal.Utf8FromString("ok"), thirdparty.QoiIsFormat([]u8{'q', 'o', 'i', 'f'}))
}
