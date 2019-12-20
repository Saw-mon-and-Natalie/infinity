#ifdef GL_ES
    precision highp float;
    precision highp int;
#endif

#define PROCESSING_TEXTURE_SHADER
#define PI 3.14159265359

uniform sampler2D texture;
uniform sampler2D imageTexture;
uniform vec2 texOffset;

uniform vec2 resolution;

uniform float zoom1;
uniform float zoom2;

uniform float angle1;
uniform float angle2;

uniform float x, y;

uniform float time;

uniform float w0;
uniform float w1;
uniform float w2;
uniform float w3;
uniform float w4;

varying vec4 vertColor;
varying vec4 vertTexCoord;

mat3 rotate(float angle) {
    float rad = angle * PI / 360.0;
    return mat3(
         cos(rad), sin(rad), 0,
        -sin(rad), cos(rad), 0,
                0,        0, 1
    );
}

mat3 scale(float s) {
    return  mat3(
        s, 0, 0,
        0, s, 0,
        0, 0, 1
    );
}

mat3 backToRealCoord(float w, float h) {
    return mat3(
        w, 0, 0,
        0, h, 0,
        -w / 2.0, -h / 2.0, 1
    );
}

mat3 backToNormalCoord(float w, float h) {
    return mat3(
        1/w,   0, 0,
          0, 1/h, 0,
        0.5, 0.5, 1
    );
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec4 leakedSignal(sampler2D tex, vec2 uv) {
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

    color = col0 + 1.0 * ( col1 + col2 + col3 + col4 ) + 1.0 * ( col5 + col6 + col7 + col8);
    color = 1.0 / 9.0 * color;
    return color;
}

vec4 grayScale(vec4 c) {
    return vec4(vec3((c.r + c.g + c.b) / 3.0), 1.0);
}

vec4 mixColors(vec4 c[5]) {
    float weights[5];
    float sumWeights = 0;
    weights[0] = w0;
    weights[1] = w1;
    weights[2] = w2;
    weights[3] = w3;
    weights[4] = w4;

    vec4 avg = vec4(0);
    for(int i=0; i<5; i++) {
        avg += weights[i] * c[i];
        sumWeights += weights[i];
    }

    avg /= sumWeights;

    return avg;

}



void main() {
    float w = resolution.x;
    float h = resolution.y;
    vec2 uv = vertTexCoord.st;
    vec3 p1 = backToNormalCoord(w, h) * scale(zoom1) * rotate(angle1) * backToRealCoord(w, h) * vec3(uv, 1.0);
    vec3 p2 = backToRealCoord(w, h) * vec3(uv, 1.0);
    p2 = p2 - vec3(x,y, 0);
    p2 = scale(zoom2) * rotate(angle2) * p2;
    p2 = p2 + vec3(x,y, 0);
    p2 = backToNormalCoord(w, h) * p2;

    // float r = rand(uv + time * 0.01);
    // r = 2.0 * r - 1.0;

    vec4 col0 = texture2D(texture, uv);
    vec4 col1 = texture2D(texture, p1.xy);
    vec4 col2 = leakedSignal(imageTexture, uv);
    vec4 col3 = leakedSignal(texture, uv);
    vec4 col4 = texture2D(texture, p2.xy);

    // col3 = grayScale(col3) ;
    // col3 = step(col3, vec4(0.5));
    // col3 = vec4(col3.rgb, 1.0);

    vec4 color = mixColors(vec4[5](col0, col1, col2, col3, col4));

    color = clamp(color, vec4(0), vec4(1));
    //color.a = 1.0;
    gl_FragColor = color;
}