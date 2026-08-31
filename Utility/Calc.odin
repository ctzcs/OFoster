package foster_utility

import runtime ".."
import spatial "../Spatial"
import "core:math"
import "core:strconv"
import "core:strings"
import "base:intrinsics"

Clamp :: runtime.Clamp
Clamp01 :: runtime.Clamp01
Round :: runtime.Round
Floor :: runtime.Floor
Ceil :: runtime.Ceil
Min :: runtime.Min
Min3 :: runtime.Min3
Min4 :: runtime.Min4
Max :: runtime.Max
Max3 :: runtime.Max3
Max4 :: runtime.Max4
ApproachScalar :: runtime.Approach
MapNormalized :: runtime.Map
MapTo :: runtime.MapTo
ClampedMapNormalized :: runtime.ClampedMap
ClampedMapTo :: runtime.ClampedMapTo
YoYo :: runtime.YoYo
OnInterval :: runtime.OnInterval
BetweenInterval :: runtime.BetweenInterval
PI :: runtime.PI
HalfPI :: runtime.HalfPI
TAU :: runtime.TAU
DegToRad :: runtime.DegToRad
RadToDeg :: runtime.RadToDeg
Right :: f32(0)
Left :: PI
Up :: PI + HalfPI
Down :: HalfPI
UpRight :: TAU - PI * 0.25
DownRight :: PI * 0.25
UpLeft :: TAU - PI * 0.75
DownLeft :: PI * 0.75
MapRange :: runtime.MapTo

IsBitSet :: proc(value: $T, position: int) -> bool { return (value & (T(1) << T(position))) != 0 }
GiveMe :: proc(index: int, choices: []$T) -> T { if index < 0 || index >= len(choices) do return {}; return choices[index] }
SignsMatch :: proc(a, b: f32) -> bool { return math.sign(a) == math.sign(b) }
Squared :: proc(v: f32) -> f32 { return v*v }
AvgFloat :: proc(values: []f32) -> f32 { if len(values)==0{return 0};sum:f32=0;for v in values{sum+=v};return sum/f32(len(values)) }
AvgVec2 :: proc(values: []spatial.Vec2) -> spatial.Vec2 { if len(values)==0{return {}};sum:spatial.Vec2={};for v in values{sum[0]+=v[0];sum[1]+=v[1]};return spatial.Vec2{sum[0]/f32(len(values)),sum[1]/f32(len(values))} }
Avg :: proc{AvgFloat, AvgVec2}
OffsetPoint2Slice :: proc(points: []runtime.Point2, offset: runtime.Point2) -> []runtime.Point2 { for i := 0; i < len(points); i += 1 { points[i] = runtime.Point2{points[i].X + offset.X, points[i].Y + offset.Y} }; return points }
TriangleArea :: proc(a,b,c:spatial.Vec2)->f32{return math.abs((a[0]*(b[1]-c[1])+b[0]*(c[1]-a[1])+c[0]*(a[1]-b[1]))*.5)}
Cross :: proc(a,b:spatial.Vec2)->f32{return a[0]*b[1]-a[1]*b[0]}
SignCross :: proc(a,b:spatial.Vec2)->int{return int(math.sign(Cross(a,b)))}
Orient :: proc(a,b,c:spatial.Vec2)->int{return SignCross(spatial.Vec2{b[0]-a[0],b[1]-a[1]},spatial.Vec2{c[0]-a[0],c[1]-a[1]})}
TriangleContainsPoint :: proc(a,b,c,p:spatial.Vec2)->bool{return math.abs(Orient(a,b,p)+Orient(b,c,p)+Orient(c,a,p))==3}
AbsDot :: proc(a,b:spatial.Vec2)->f32{return math.abs(spatial_vec2_dot(a,b))}
DotSq :: proc(a,b:spatial.Vec2)->f32{d:=spatial_vec2_dot(a,b);return math.sign(d)*d*d}
AbsDotSq :: proc(a,b:spatial.Vec2)->f32{d:=spatial_vec2_dot(a,b);return d*d}
spatial_vec2_dot :: proc(a,b:spatial.Vec2)->f32{return a[0]*b[0]+a[1]*b[1]}

ApproachVec2 :: proc(from,target:spatial.Vec2,amount:f32)->spatial.Vec2{if from==target{return target};d:=spatial.Vec2{target[0]-from[0],target[1]-from[1]};if d[0]*d[0]+d[1]*d[1]<=amount*amount{return target};l:=math.sqrt(d[0]*d[0]+d[1]*d[1]);return spatial.Vec2{from[0]+d[0]/l*amount,from[1]+d[1]/l*amount}}
Approach3 :: proc(from,target:spatial.Vec3,amount:f32)->spatial.Vec3{if from==target{return target};d:=spatial.Vec3{target[0]-from[0],target[1]-from[1],target[2]-from[2]};l2:=d[0]*d[0]+d[1]*d[1]+d[2]*d[2];if l2<=amount*amount{return target};l:=math.sqrt(l2);return spatial.Vec3{from[0]+d[0]/l*amount,from[1]+d[1]/l*amount,from[2]+d[2]/l*amount}}
ApproachRefScalar :: proc(from:^f32,target,amount:f32)->f32 { from^=ApproachScalar(from^,target,amount); return from^ }
ApproachRefVec2 :: proc(from:^spatial.Vec2,target:spatial.Vec2,amount:f32)->spatial.Vec2 { from^=ApproachVec2(from^,target,amount); return from^ }
Approach :: proc{ApproachScalar, ApproachVec2, Approach3}
ApproachIfLower :: proc(from, target, amount: f32) -> f32 { if SignsMatch(from, target) && math.abs(from) >= math.abs(target) { return from }; return ApproachScalar(from, target, amount) }
MapExtended :: proc(val,min_value,max_value,new_min,new_max:f32)->f32{return ((val-min_value)/(max_value-min_value))*(new_max-new_min)+new_min}
Map :: proc{MapNormalized, MapExtended}
ClampedMapExtended :: proc(val,min_value,max_value,new_min,new_max:f32)->f32{return Clamp01((val-min_value)/(max_value-min_value))*(new_max-new_min)+new_min}
ClampedMap :: proc{ClampedMapNormalized, ClampedMapExtended}
RotateToward :: proc(dir,target:spatial.Vec2,max_angle_delta,max_magnitude_delta:f32)->spatial.Vec2{angle:=Angle(dir);length:=spatial_vec2_length(dir);if max_angle_delta>0{angle=AngleApproach(angle,Angle(target),max_angle_delta)};if max_magnitude_delta>0{length=Approach(length,spatial_vec2_length(target),max_magnitude_delta)};return AngleToVector(angle,length)}

SineMap :: proc(radians,new_min,new_max:f32)->f32{return MapRange(math.sin(radians),-1,1,new_min,new_max)}
AngleVector :: proc(v:spatial.Vec2)->f32{return math.atan2(v[1],v[0])}
AngleBetween :: proc(from,to:spatial.Vec2)->f32{return math.atan2(to[1]-from[1],to[0]-from[0])}
Angle :: proc{AngleVector, AngleBetween}
AngleToVector :: proc(angle:f32,length:f32=1)->spatial.Vec2{return spatial.Vec2{math.cos(angle)*length,math.sin(angle)*length}}
AngleWrap :: proc(angle:f32)->f32{result:=math.mod(angle,TAU);if result<0{result+=TAU};return result}
AngleDiff :: proc(a,b:f32)->f32{result:=math.mod(b-a-PI,TAU);if result<0{result+=TAU};return result-PI}
AbsAngleDiff :: proc(a,b:f32)->f32{return math.abs(AngleDiff(a,b))}
AngleApproach :: proc(value,target,max_move:f32)->f32{d:=AngleDiff(value,target);if math.abs(d)<max_move{return target};return value+Clamp(d,-max_move,max_move)}
AngleLerp :: proc(a,b,percent:f32)->f32{return a+AngleDiff(a,b)*percent}
AngleReflectOnX :: proc(angle:f32)->f32{return AngleWrap(-angle)}
AngleReflectOnY :: proc(angle:f32)->f32{return AngleWrap(HalfPI-(angle-HalfPI))}
spatial_vec2_length :: proc(v:spatial.Vec2)->f32{return math.sqrt(v[0]*v[0]+v[1]*v[1])}

NextPowerOfTwo :: proc(x:int)->int{if x<=0{return 0};if x==1{return 1};v:=x-1;v|=v>>1;v|=v>>2;v|=v>>4;v|=v>>8;v|=v>>16;return v+1}
Approx :: proc(a,b:f32)->bool{return math.abs(a-b)<=0.001}
GetBresenhamsLine :: proc(a,b:runtime.Point2)->[dynamic]runtime.Point2{result:[dynamic]runtime.Point2={};aa:=a;bb:=b;steep:=math.abs(bb.Y-aa.Y)>math.abs(bb.X-aa.X);if steep{aa.X,aa.Y=aa.Y,aa.X;bb.X,bb.Y=bb.Y,bb.X};if aa.X>bb.X{aa.X,bb.X=bb.X,aa.X;aa.Y,bb.Y=bb.Y,aa.Y};dx:=bb.X-aa.X;dy:=math.abs(bb.Y-aa.Y);err:=dx/2;ystep:=1;if aa.Y>=bb.Y{ystep=-1};y:=aa.Y;for x:=aa.X;x<=bb.X;x+=1{if steep{append(&result,runtime.Point2{y,x})}else{append(&result,runtime.Point2{x,y})};err-=dy;if err<0{y+=ystep;err+=dx}};return result}
SolveQuadratic :: proc(a,b,c:f32)->(bool,f32,f32){d:=b*b-4*a*c;if d<0{return false,0,0};if d==0{r:=-b/(2*a);return true,r,r};s:=math.sqrt(d);return true,(-b+s)/(2*a),(-b-s)/(2*a)}

GetClosestPointIndexVec2 :: proc(points:[]spatial.Vec2,to:spatial.Vec2)->int{best:=-1;dist:f32=0;for i:=0;i<len(points);i+=1{p:=points[i];dx:=p[0]-to[0];dy:=p[1]-to[1];d:=dx*dx+dy*dy;if best<0||d<dist{best=i;dist=d}};return best}
GetFurthestPointIndexVec2 :: proc(points:[]spatial.Vec2,to:spatial.Vec2)->int{best:=-1;dist:f32=0;for i:=0;i<len(points);i+=1{p:=points[i];dx:=p[0]-to[0];dy:=p[1]-to[1];d:=dx*dx+dy*dy;if best<0||d>dist{best=i;dist=d}};return best}
GetClosestPointIndexPoint2 :: proc(points:[]runtime.Point2,to:spatial.Vec2)->int{best:=-1;dist:f32=0;for i:=0;i<len(points);i+=1{p:=points[i];dx:=f32(p.X)-to[0];dy:=f32(p.Y)-to[1];d:=dx*dx+dy*dy;if best<0||d<dist{best=i;dist=d}};return best}
GetFurthestPointIndexPoint2 :: proc(points:[]runtime.Point2,to:spatial.Vec2)->int{best:=-1;dist:f32=0;for i:=0;i<len(points);i+=1{p:=points[i];dx:=f32(p.X)-to[0];dy:=f32(p.Y)-to[1];d:=dx*dx+dy*dy;if best<0||d>dist{best=i;dist=d}};return best}
GetClosestPointIndex :: proc{GetClosestPointIndexVec2, GetClosestPointIndexPoint2}
GetFurthestPointIndex :: proc{GetFurthestPointIndexVec2, GetFurthestPointIndexPoint2}

Smallest :: proc(values: []$T) -> int { if len(values)==0{return -1}; best:=0; for i:=1;i<len(values);i+=1 { if values[i] < values[best] {best=i} }; return best }
Largest :: proc(values: []$T) -> int { if len(values)==0{return -1}; best:=0; for i:=1;i<len(values);i+=1 { if values[i] > values[best] {best=i} }; return best }

GetClosestValueIndex :: proc(values: []$T, to: T) -> int where intrinsics.type_is_numeric(T) { best:int=-1; dist:T={}; for v,i in values { d:T=v-to; if d<T(0) {d=-d}; if best<0 || d < dist {best=i;dist=d} }; return best }
GetFurthestValueIndex :: proc(values: []$T, to: T) -> int where intrinsics.type_is_numeric(T) { best:int=-1; dist:T={}; for v,i in values { d:T=v-to; if d<T(0) {d=-d}; if best<0 || d > dist {best=i;dist=d} }; return best }
GetClosestValue :: proc(values: []$T, to: T) -> T where intrinsics.type_is_numeric(T) { i:=GetClosestValueIndex(values,to); if i<0{return {}}; return values[i] }
GetFurthestValue :: proc(values: []$T, to: T) -> T where intrinsics.type_is_numeric(T) { i:=GetFurthestValueIndex(values,to); if i<0{return {}}; return values[i] }
GetClosestPointVec2 :: proc(points:[]spatial.Vec2,to:spatial.Vec2)->spatial.Vec2{i:=GetClosestPointIndexVec2(points,to);if i<0{return {}};return points[i]}
GetFurthestPointVec2 :: proc(points:[]spatial.Vec2,to:spatial.Vec2)->spatial.Vec2{i:=GetFurthestPointIndexVec2(points,to);if i<0{return {}};return points[i]}
GetClosestPointPoint2 :: proc(points:[]runtime.Point2,to:spatial.Vec2)->runtime.Point2{i:=GetClosestPointIndexPoint2(points,to);if i<0{return {}};return points[i]}
GetFurthestPointPoint2 :: proc(points:[]runtime.Point2,to:spatial.Vec2)->runtime.Point2{i:=GetFurthestPointIndexPoint2(points,to);if i<0{return {}};return points[i]}
GetClosestPoint :: proc{GetClosestPointVec2, GetClosestPointPoint2}
GetFurthestPoint :: proc{GetFurthestPointVec2, GetFurthestPointPoint2}

Lerp :: proc(a,b,percent:f32)->f32{return a+(b-a)*percent}
ClampedLerp :: proc(a,b,percent:f32)->f32{return Lerp(a,b,Clamp01(percent))}
Bezier3 :: proc(a,b,c,t:f32)->f32{return Lerp(Lerp(a,b,t),Lerp(b,c,t),t)}
Bezier4 :: proc(a,b,c,d,t:f32)->f32{return Bezier3(Lerp(a,b,t),Lerp(b,c,t),Lerp(c,d,t),t)}
BezierVec3 :: proc(a,b,c:spatial.Vec2,t:f32)->spatial.Vec2{return spatial.Vec2{Bezier3(a[0],b[0],c[0],t),Bezier3(a[1],b[1],c[1],t)}}
BezierVec4 :: proc(a,b,c,d:spatial.Vec2,t:f32)->spatial.Vec2{return BezierVec3(spatial.Vec2{Lerp(a[0],b[0],t),Lerp(a[1],b[1],t)},spatial.Vec2{Lerp(b[0],c[0],t),Lerp(b[1],c[1],t)},spatial.Vec2{Lerp(c[0],d[0],t),Lerp(c[1],d[1],t)},t)}
Bezier :: proc{Bezier3, Bezier4, BezierVec3, BezierVec4}

SnapScalar :: proc(value,interval:f32)->f32{if interval==0{return value};return math.round(value/interval)*interval}
SnapFloorScalar :: proc(value,interval:f32)->f32{if interval==0{return value};return math.floor(value/interval)*interval}
SnapCeilScalar :: proc(value,interval:f32)->f32{if interval==0{return value};return math.ceil(value/interval)*interval}
SnapVec2 :: proc(value,interval:spatial.Vec2)->spatial.Vec2{return spatial.Vec2{SnapScalar(value[0],interval[0]),SnapScalar(value[1],interval[1])}}
SnapFloorVec2 :: proc(value,interval:spatial.Vec2)->spatial.Vec2{return spatial.Vec2{SnapFloorScalar(value[0],interval[0]),SnapFloorScalar(value[1],interval[1])}}
SnapCeilVec2 :: proc(value,interval:spatial.Vec2)->spatial.Vec2{return spatial.Vec2{SnapCeilScalar(value[0],interval[0]),SnapCeilScalar(value[1],interval[1])}}
SnapFloatPoint2 :: proc(value: spatial.Vec2, interval: runtime.Point2) -> runtime.Point2 { return runtime.Point2{int(math.round(value[0]/f32(interval.X)))*interval.X, int(math.round(value[1]/f32(interval.Y)))*interval.Y} }
SnapScalarVec2 :: proc(value: spatial.Vec2, interval: f32) -> spatial.Vec2 { return spatial.Vec2{Snap(value[0],interval),Snap(value[1],interval)} }
SnapIntPoint2 :: proc(value: spatial.Vec2, interval: int) -> runtime.Point2 { return runtime.Point2{int(math.round(value[0]/f32(interval)))*interval,int(math.round(value[1]/f32(interval)))*interval} }
Snap :: proc{SnapScalar, SnapVec2, SnapFloatPoint2, SnapScalarVec2, SnapIntPoint2}
SnapFloorFloatPoint2 :: proc(value: spatial.Vec2, interval: runtime.Point2) -> runtime.Point2 { return runtime.Point2{int(math.floor(value[0]/f32(interval.X)))*interval.X, int(math.floor(value[1]/f32(interval.Y)))*interval.Y} }
SnapFloorScalarVec2 :: proc(value: spatial.Vec2, interval: f32) -> spatial.Vec2 { return spatial.Vec2{SnapFloor(value[0],interval),SnapFloor(value[1],interval)} }
SnapFloorIntPoint2 :: proc(value: spatial.Vec2, interval: int) -> runtime.Point2 { return runtime.Point2{int(math.floor(value[0]/f32(interval)))*interval,int(math.floor(value[1]/f32(interval)))*interval} }
SnapFloor :: proc{SnapFloorScalar, SnapFloorVec2, SnapFloorFloatPoint2, SnapFloorScalarVec2, SnapFloorIntPoint2}
SnapCeilFloatPoint2 :: proc(value: spatial.Vec2, interval: runtime.Point2) -> runtime.Point2 { return runtime.Point2{int(math.ceil(value[0]/f32(interval.X)))*interval.X, int(math.ceil(value[1]/f32(interval.Y)))*interval.Y} }
SnapCeilScalarVec2 :: proc(value: spatial.Vec2, interval: f32) -> spatial.Vec2 { return spatial.Vec2{SnapCeil(value[0],interval),SnapCeil(value[1],interval)} }
SnapCeilIntPoint2 :: proc(value: spatial.Vec2, interval: int) -> runtime.Point2 { return runtime.Point2{int(math.ceil(value[0]/f32(interval)))*interval,int(math.ceil(value[1]/f32(interval)))*interval} }
SnapCeil :: proc{SnapCeilScalar, SnapCeilVec2, SnapCeilFloatPoint2, SnapCeilScalarVec2, SnapCeilIntPoint2}

MoveVec2 :: proc(points: []spatial.Vec2, delta: spatial.Vec2) -> []spatial.Vec2 { for i:=0;i<len(points);i+=1 { points[i] += delta }; return points }
InsideTriangle :: proc(a,b,c,p: spatial.Vec2) -> bool { return TriangleContainsPoint(a,b,c,p) }

ParseVector2 :: proc(value: string, delimiter: u8) -> (spatial.Vec2, bool) {
	result: spatial.Vec2 = {}; start:=0; parts:[dynamic]f32={}; defer delete(parts)
	for i:=0; i<=len(value); i+=1 { if i==len(value) || value[i]==delimiter { if i==start{return result,false}; v,ok:=strconv.parse_f32(value[start:i]); if !ok{return result,false}; append(&parts,v); start=i+1 } }
	if len(parts)!=2{return result,false}; return spatial.Vec2{parts[0],parts[1]},true
}
ParseVector3 :: proc(value: string, delimiter: u8) -> (spatial.Vec3, bool) {
	result: spatial.Vec3 = {}; start:=0; parts:[dynamic]f32={}; defer delete(parts)
	for i:=0; i<=len(value); i+=1 { if i==len(value) || value[i]==delimiter { if i==start{return result,false}; v,ok:=strconv.parse_f32(value[start:i]); if !ok{return result,false}; append(&parts,v); start=i+1 } }
	if len(parts)!=3{return result,false}; return spatial.Vec3{parts[0],parts[1],parts[2]},true
}

StaticStringHashString :: proc(value: string) -> int { hash:u32=5381; for b in value { hash = (hash << 5) + hash + u32(b) }; return int(i32(hash)) }
StaticStringHashBytes :: proc(value: []u8) -> int { hash:u32=5381; for b in value { hash = (hash << 5) + hash + u32(b) }; return int(i32(hash)) }
StaticStringHash :: proc{StaticStringHashString, StaticStringHashBytes}
EqualsOrdinalIgnoreCaseUtf8String :: proc(a,b: string) -> bool { if len(a)!=len(b){return false}; for i:=0;i<len(a);i+=1 {ca:=a[i];cb:=b[i];if ca>='A'&&ca<='Z'{ca+=32};if cb>='A'&&cb<='Z'{cb+=32};if ca!=cb{return false}};return true }
EqualsOrdinalIgnoreCaseUtf8Bytes :: proc(a,b: []u8) -> bool { if len(a)!=len(b){return false}; for i:=0;i<len(a);i+=1 {ca:=a[i];cb:=b[i];if ca>='A'&&ca<='Z'{ca+=32};if cb>='A'&&cb<='Z'{cb+=32};if ca!=cb{return false}};return true }
EqualsOrdinalIgnoreCaseUtf8 :: proc{EqualsOrdinalIgnoreCaseUtf8String, EqualsOrdinalIgnoreCaseUtf8Bytes}
AmountInCommon :: proc(a,b: string) -> int { n:=0; for i:=0; i<min(len(a),len(b)); i+=1 { if a[i]==b[i] {n+=1} else {break} }; return n }
NormalizePathSingle :: proc(path: string) -> string { b:=strings.builder_make(); defer strings.builder_destroy(&b); previous_slash:=false; for c in path { if c=='\\' || c=='/' {if !previous_slash {strings.write_byte(&b,'/');previous_slash=true}} else {strings.write_rune(&b,c);previous_slash=false} }; return strings.to_string(b) }
NormalizePathPair :: proc(a,b: string) -> string { bld:=strings.builder_make(); defer strings.builder_destroy(&bld); strings.write_string(&bld,a); strings.write_byte(&bld,'/'); strings.write_string(&bld,b); return NormalizePathSingle(strings.to_string(bld)) }
NormalizePathTriple :: proc(a,b,c: string) -> string { bld:=strings.builder_make(); defer strings.builder_destroy(&bld); strings.write_string(&bld,a); strings.write_byte(&bld,'/'); strings.write_string(&bld,b); strings.write_byte(&bld,'/'); strings.write_string(&bld,c); return NormalizePathSingle(strings.to_string(bld)) }
NormalizePath :: proc{NormalizePathSingle, NormalizePathPair, NormalizePathTriple}
Swap :: proc(a,b:^$T) { t:=a^; a^=b^; b^=t }

SmoothDamp :: proc(current,target:f32, velocity:^f32, smooth_time,max_speed,delta_time:f32) -> f32 { st:=math.max(0.0001,smooth_time); omega:=2/st; x:=omega*delta_time; exp:=1/(1+x+0.48*x*x+0.235*x*x*x); change:=current-target; original:=target; max_change:=max_speed*st; change=Clamp(change,-max_change,max_change); adjusted_target:=current-change; temp:=(velocity^+omega*change)*delta_time; velocity^=(velocity^-omega*temp)*exp; output:=adjusted_target+(change+temp)*exp; if (original-current)*(output-original)>0 {output=original;velocity^=(output-original)/delta_time}; return output }

tri_area :: proc(vertices: []spatial.Vec2) -> f32 { area:f32=0; if len(vertices)<3{return 0}; p:=len(vertices)-1; for q:=0;q<len(vertices);q+=1 { area += vertices[p][0]*vertices[q][1]-vertices[q][0]*vertices[p][1]; p=q }; return area*0.5 }
tri_inside :: proc(a,b,c,p: spatial.Vec2) -> bool { p0:=c-b; p1:=a-c; p2:=b-a; ap:=p-a; bp:=p-b; cp:=p-c; return Cross(p0,bp)>=0 && Cross(p2,ap)>=0 && Cross(p1,cp)>=0 }
Triangulate :: proc(vertices: []spatial.Vec2, indices: ^[dynamic]int) {
	clear(indices)
	n := len(vertices)
	if n < 3 { return }
	v: [dynamic]int = {}
	defer delete(v)
	if tri_area(vertices) > 0 {
		for i := 0; i < n; i += 1 { append(&v, i) }
	} else {
		for i := 0; i < n; i += 1 { append(&v, n-1-i) }
	}
	nv := n
	count := 2 * nv
	m := nv - 1
	for nv > 2 {
		if count <= 0 { return }
		count -= 1
		u := m
		if u >= nv { u = 0 }
		vv := u + 1
		if vv >= nv { vv = 0 }
		w := vv + 1
		if w >= nv { w = 0 }
		a := vertices[v[u]]
		b := vertices[v[vv]]
		c := vertices[v[w]]
		if Cross(b-a, c-a) > 0 {
			snip := true
			for p := 0; p < nv; p += 1 {
				if p == u || p == vv || p == w { continue }
				if tri_inside(a, b, c, vertices[v[p]]) { snip = false; break }
			}
			if snip {
				append(&indices^, v[u], v[vv], v[w])
				for s, t := vv, vv+1; t < nv; s, t = s+1, t+1 { v[s] = v[t] }
				nv -= 1
				count = 2 * nv
				m = vv
			}
		} else {
			m = vv
		}
	}
}
