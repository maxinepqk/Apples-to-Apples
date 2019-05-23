#include <metal_stdlib>
using namespace metal;

kernel void blurShader(texture2d<float, access::read> inTexture [[texture(0)]],
                         texture2d<float, access::write> outTexture [[texture(1)]],
                         uint2 gid [[thread_position_in_grid]])
{
    
    uint w = outTexture.get_width();
    uint h = outTexture.get_height();
    if((gid.x >= w) || (gid.y >= h)) return;
    
    float c = 0;
    uint2 rid = gid;
    uint gidx_min_1 = gid.x-1;
    uint gidy_min_1 = gid.y-1;
    uint gidx_pls_1 = gid.x+1;
    uint gidy_pls_1 = gid.y+1;

    //if((gidx_min_1 < w)) {
        rid.x = gidx_min_1;
        rid.y = gidy_min_1;
        c = c + inTexture.read(rid).r / 9;
        rid.x = gidx_min_1;
        rid.y = gid.y;
        c = c + inTexture.read(rid).r / 9;
        rid.x = gidx_min_1;
        rid.y = gidy_pls_1;
        c = c + inTexture.read(rid).r / 9;
    //}
    
    rid.x = gid.x;
    rid.y = gidy_min_1;
    c = c + inTexture.read(rid).r / 9;
    //rid.x = gid.x;
    //rid.y = gid.y;
    c = c + inTexture.read(gid).r / 9;
    rid.x = gid.x;
    rid.y = gidy_pls_1;
    c = c + inTexture.read(rid).r / 9;
    
    //if((gidx_pls_1 < w)) {
        rid.x = gidx_pls_1;
        rid.y = gidy_min_1;
        c = c + inTexture.read(rid).r / 9;
        rid.x = gidx_pls_1;
        rid.y = gid.y;
        c = c + inTexture.read(rid).r / 9;
        rid.x = gidx_pls_1;
        rid.y = gidy_pls_1;
        c = c + inTexture.read(rid).r / 9;
    //}

    //c = c / 9;
    float4 outColor(c, c, c, 1);
    outTexture.write(outColor, gid);
}
