#ifdef GL_ES
    precision highp float;
    precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 texOffset;

uniform float time;

varying vec4 vertTexCoord;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 sharpen(sampler2D tex, vec2 uv) {
    vec4 color = vec4(0);
    vec4 col0 = texture2D(tex, uv);

    vec4 col1 = texture2D(tex, uv + vec2(texOffset.x, 0));
    vec4 col2 = texture2D(tex, uv - vec2(texOffset.x, 0));
    vec4 col3 = texture2D(tex, uv + vec2(0, texOffset.y));
    vec4 col4 = texture2D(tex, uv - vec2(0, texOffset.y));

    // vec4 col5 = texture2D(tex, uv + vec2(texOffset.x, texOffset.y));
    // vec4 col6 = texture2D(tex, uv - vec2(texOffset.x, texOffset.y));
    // vec4 col7 = texture2D(tex, uv + vec2(texOffset.x, -texOffset.y));
    // vec4 col8 = texture2D(tex, uv - vec2(texOffset.x, -texOffset.y));

    color = 2.0 * col0 - 0.25 * ( col1 + col2 + col3 + col4 );
    return color;
}

void main() {
    vec2 uv = vertTexCoord.st;
    vec2 coord = uv;
    coord = 2.0 * coord - 1.0;
    coord *= 0.995;
    coord = coord * 0.5 + 0.5;

    float r = rand(uv + time * 0.001);
    r = 2.0 * r - 1.0;

    vec4 color = sharpen(texture, coord);
    color = clamp(color + r * 0.025, vec4(0), vec4(1));
    color.a = 1.0;

    gl_FragColor = color;

}