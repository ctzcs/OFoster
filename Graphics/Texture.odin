package foster_graphics

import runtime ".."
import images "../Images"

Texture :: runtime.Texture
TextureMemorySize :: runtime.TextureMemorySize
TextureInit :: runtime.TextureInit
TextureInitEx :: runtime.TextureInitEx
TextureDispose :: runtime.TextureDispose
TextureSetData :: runtime.TextureSetData
TextureSampleResource :: runtime.TextureSampleResource
TextureFromImage :: proc(device:^runtime.GraphicsDevice,image:^images.Image,name:string="")->runtime.Texture{tex:runtime.Texture;if device==nil||image==nil||image.Width<=0||image.Height<=0{return tex};runtime.TextureInit(&tex,device,image.Width,image.Height,.Color,name);runtime.TextureSetData(&tex,raw_data(image.Pixels),len(image.Pixels)*size_of(runtime.Color));return tex}
