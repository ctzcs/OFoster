package foster_input

import spatial "../Spatial"
import images "../Images"
import SDL "vendor:sdl3"
import "core:c"

CursorSystemType :: enum { Default, Text, Wait, Crosshair, Progress, ResizeNWSE, ResizeNESW, ResizeHorizontal, ResizeVertical, Move, NotAllowed, Pointer, ResizeNW, ResizeN, ResizeNE, ResizeE, ResizeSE, ResizeS, ResizeSW, ResizeW }
Cursor :: struct { FocusPoint: spatial.Point2, Size: spatial.Point2, SystemType: CursorSystemType, Image: ^images.Image, Handle: ^SDL.Cursor, Disposed: bool }
cursor_sdl_system :: proc(kind: CursorSystemType) -> SDL.SystemCursor {
	return SDL.SystemCursor(kind)
}
CursorMakeSystem :: proc(kind: CursorSystemType)->Cursor{return Cursor{SystemType=kind, Handle=SDL.CreateSystemCursor(cursor_sdl_system(kind))}}
CursorMakeImage :: proc(image:^images.Image,focus:spatial.Point2)->Cursor {
	result := Cursor{FocusPoint=focus}
	if image == nil || image.Width <= 0 || image.Height <= 0 || len(image.Pixels) == 0 { return result }
	result.Size = spatial.Point2{image.Width, image.Height}
	result.Image = image
	surface := SDL.CreateSurfaceFrom(c.int(image.Width), c.int(image.Height), SDL.PixelFormat.RGBA8888, raw_data(image.Pixels), c.int(image.Width * 4))
	if surface == nil { return result }
	result.Handle = SDL.CreateColorCursor(surface, c.int(focus.X), c.int(focus.Y))
	SDL.DestroySurface(surface)
	return result
}
CursorSet :: proc(c:^Cursor) -> bool { if c == nil || c.Disposed || c.Handle == nil do return false; return SDL.SetCursor(c.Handle) }
CursorDispose :: proc(c:^Cursor){if c == nil || c.Disposed do return;if c.Handle != nil{SDL.DestroyCursor(c.Handle);c.Handle=nil};c.Disposed=true;c.Image=nil}
