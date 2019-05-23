#include <metal_stdlib>
using namespace metal;

kernel void saxpyShader(texture2d<float, access::read> inTexture [[texture(0)]],
                        texture2d<float, access::write> outTexture [[texture(1)]],
                        uint2 gid [[thread_position_in_grid]])
{
    
    uint w = outTexture.get_width();
    uint h = outTexture.get_height();
    if((gid.x >= w) || (gid.y >= h)) return;
    
    float a = 3.1415926535897932384626433832795;
    
    float ax = inTexture.read(gid).r * a;
    gid.y++;
    float y = inTexture.read(gid).r;
    
    float c = ax + y;
    
    float4 outColor(c, c, c, 1);
    outTexture.write(outColor, gid);
}
