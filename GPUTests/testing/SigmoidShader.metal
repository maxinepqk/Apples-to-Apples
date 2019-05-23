#include <metal_stdlib>
using namespace metal;

kernel void sigmoidShader(texture2d<float, access::read> inTexture [[texture(0)]],
                         texture2d<float, access::write> outTexture [[texture(1)]],
                         uint2 gid [[thread_position_in_grid]])
{
    
    uint w = outTexture.get_width();
    uint h = outTexture.get_height();
    if((gid.x >= w) || (gid.y >= h)) return;
    
    float c = inTexture.read(gid).r;
    
    c = 1.0f / (1.0f + exp(-c));

    float4 outColor(c, c, c, 1);
    outTexture.write(outColor, gid);
}
