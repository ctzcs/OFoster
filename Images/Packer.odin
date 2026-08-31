package foster_images

import runtime ".."
import spatial "../Spatial"

PackerEntry :: struct { Index:int, Name:string, Page:int, Source:spatial.RectInt, Frame:spatial.RectInt }
PackerOutput :: struct { Pages:[dynamic]Image, Entries:[dynamic]PackerEntry }
PackerSource :: struct { Index:int, Name:string, Image:Image, Frame:spatial.RectInt, DuplicateOf:int }
Packer :: struct { Trim:bool, MaxSize:int, Padding:int, PowerOfTwo:bool, DuplicateEdges:bool, CombineDuplicates:bool, Sources:[dynamic]PackerSource }
PackerMake :: proc()->Packer { return Packer{Trim=true,MaxSize=8192,Padding=1} }

packer_alpha :: proc(i:^Image,x,y:int)->u8{return ImageGetPixel(i,x,y).A}
packer_same :: proc(a,b:Image)->bool{if a.Width!=b.Width||a.Height!=b.Height{return false};for n in 0..<len(a.Pixels){if a.Pixels[n]!=b.Pixels[n]{return false}};return true}
PackerAdd :: proc(p:^Packer,name:string,image:Image)->int{
	idx:=len(p.Sources); source:=image; source_ref:=image; frame:=spatial.RectInt{0,0,image.Width,image.Height}
	if p.Trim&&image.Width>0&&image.Height>0 { left,right,top,bottom:=image.Width,0,image.Height,0; for y in 0..<image.Height{for x in 0..<image.Width{if packer_alpha(&source_ref,x,y)>0{if x<left{left=x};if x>=right{right=x+1};if y<top{top=y};if y>=bottom{bottom=y+1}}}}; if right>left&&bottom>top { frame=spatial.RectInt{-left,-top,image.Width,image.Height}; source=ImageMake(right-left,bottom-top); ImageCopyPixels(&source,&source_ref,spatial.RectInt{left,top,right-left,bottom-top},runtime.Point2{}) } else { source=ImageMake(0,0) } }
	dup:=-1; if p.CombineDuplicates&&source.Width>0 { for old in p.Sources { if old.DuplicateOf<0&&packer_same(old.Image,source){dup=old.Index;break} } }
	append(&p.Sources,PackerSource{Index=idx,Name=name,Image=source,Frame=frame,DuplicateOf=dup}); return idx
}
PackerAddImage :: PackerAdd
PackerClear :: proc(p:^Packer){clear(&p.Sources)}
packer_next_pow2 :: proc(v:int)->int{n:=1;for n<v{n*=2};return n}
packer_flush :: proc(p:^Packer,out:^PackerOutput,page:^Image,used_w,used_h:int){if used_w<=0||used_h<=0{return};w,h:=used_w,used_h;if p.PowerOfTwo{w=packer_next_pow2(w);h=packer_next_pow2(h)};if w>p.MaxSize{w=p.MaxSize};if h>p.MaxSize{h=p.MaxSize};cropped:=ImageMake(w,h);ImageCopyPixels(&cropped,page,spatial.RectInt{0,0,w,h},runtime.Point2{});append(&out.Pages,cropped)}

PackerPack :: proc(p:^Packer)->PackerOutput{
	out:=PackerOutput{};if p==nil||len(p.Sources)==0{return out};max_size:=p.MaxSize;if max_size<=0{return out};padding:=p.Padding;if padding<0{padding=0}
	page:=ImageMake(max_size,max_size);x,y,row,used_w,used_h:=0,0,0,0,0
	order:[dynamic]int = {};for i in 0..<len(p.Sources){area:=p.Sources[i].Image.Width*p.Sources[i].Image.Height;at:=len(order);for j in 0..<len(order){other:=p.Sources[order[j]].Image.Width*p.Sources[order[j]].Image.Height;if other<area{at=j;break}};append(&order,0);for j:=len(order)-1;j>at;j-=1{order[j]=order[j-1]};order[at]=i}
	for oi in order { s:=p.Sources[oi]
		if s.DuplicateOf>=0||s.Image.Width<=0||s.Image.Height<=0{continue}; w,h:=s.Image.Width,s.Image.Height
		if w+padding>max_size||h+padding>max_size{continue}
		if x+w+padding>max_size{x=0;y+=row+padding;row=0}
		if y+h+padding>max_size{packer_flush(p,&out,&page,used_w,used_h);page=ImageMake(max_size,max_size);x,y,row,used_w,used_h=0,0,0,0,0}
		pos:=spatial.RectInt{x+padding/2,y+padding/2,w,h};src:=s.Image;ImageCopyPixels(&page,&src,spatial.RectInt{0,0,w,h},runtime.Point2{pos.X,pos.Y})
		if p.DuplicateEdges&&padding>=2{for yy in 0..<h{ImageSetPixel(&page,pos.X-1,pos.Y+yy,ImageGetPixel(&page,pos.X,pos.Y+yy));ImageSetPixel(&page,pos.X+w,pos.Y+yy,ImageGetPixel(&page,pos.X+w-1,pos.Y+yy))};for xx in -1..<(w+1){ImageSetPixel(&page,pos.X+xx,pos.Y-1,ImageGetPixel(&page,pos.X+xx,pos.Y));ImageSetPixel(&page,pos.X+xx,pos.Y+h,ImageGetPixel(&page,pos.X+xx,pos.Y+h-1))}}
		append(&out.Entries,PackerEntry{s.Index,s.Name,len(out.Pages),pos,s.Frame});x+=w+padding;if h>row{row=h};if pos.X+w>used_w{used_w=pos.X+w};if pos.Y+h>used_h{used_h=pos.Y+h}
	}
	packer_flush(p,&out,&page,used_w,used_h)
	for s in p.Sources { if s.DuplicateOf>=0 { for e in out.Entries{if e.Index==s.DuplicateOf{append(&out.Entries,PackerEntry{s.Index,s.Name,e.Page,e.Source,s.Frame});break}} } else if s.Image.Width<=0||s.Image.Height<=0 { append(&out.Entries,PackerEntry{s.Index,s.Name,0,spatial.RectInt{},s.Frame}) } }
	return out
}
