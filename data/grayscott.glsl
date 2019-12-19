#ifdef GL_ES
    precision highp float;
    precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform sampler2D imageTexture;
uniform vec2 texOffset;

uniform float f;
uniform float k;
uniform float dt;
uniform float dA;
uniform float dB;

uniform float s11, s12, s21, s22;

varying vec4 vertTexCoord;

vec4 laplace(sampler2D tex, vec2 uv) {
    vec4 color = vec4(0);
    vec4 col0 = texture2D(tex, uv);

    vec4 col1 = texture2D(tex, uv + vec2(texOffset.x, 0));
    vec4 col2 = texture2D(tex, uv - vec2(texOffset.x, 0));
    vec4 col3 = texture2D(tex, uv + vec2(0, texOffset.y));
    vec4 col4 = texture2D(tex, uv - vec2(0, texOffset.y));

    vec4 col5 = texture2D(tex, uv + vec2(texOffset.x, texOffset.y));
    vec4 col6 = texture2D(tex, uv - vec2(texOffset.x, texOffset.y));
    vec4 col7 = texture2D(tex, uv + vec2(texOffset.x, -texOffset.y));
    vec4 col8 = texture2D(tex, uv - vec2(texOffset.x, -texOffset.y));

    color = -1.0 * col0 + 
            0.20 * ( col1 + col2 + col3 + col4 ) + 
            0.05 * ( col5 + col6 + col7 + col8 );

    return color;
}

void main() {
    vec2 uv = vertTexCoord.st;
    vec4 lapl = laplace(texture, uv);

    vec4 ab = vec4(0);
    ab = texture2D(imageTexture, uv);
    uv = texture2D(texture, uv).rg;

    // uv.r += s11 * ab.r + s12 * ab.g;
    // uv.g += s21 * ab.r + s22 * ab.g;
    

    float rate = uv.r * uv.g * uv.g;
    float du = dA * lapl.r - rate + f * (1.0 - uv.r);
    float dv = dB * lapl.g + rate - (f+k) * uv.g;  

    du += s11 * ab.r + s12 * ab.g;
    dv += s21 * ab.r + s22 * ab.g;

    float u = clamp(uv.r + du*dt,0.0,1.0); 
    float v = clamp(uv.g + dv*dt,0.0,1.0); 

    gl_FragColor = vec4( u, v,0.0, 1.0); 
}