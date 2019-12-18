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
uniform float zoom;
uniform float angle;

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



void main() {
    float w = resolution.x;
    float h = resolution.y;
    vec2 uv = vertTexCoord.st;
    vec3 p =  backToNormalCoord(w, h) * scale(zoom) * rotate(angle) * backToRealCoord(w, h) * vec3(uv, 1.0);
    vec2 p1 = p.xy;

    vec4 col1 = texture2D(texture, uv);
    vec4 col2 = texture2D(texture, p1);
    vec4 col3 = texture2D(imageTexture, uv);

    vec4 color = vec4(0);
    color = 0.2 * col1 + 0.7 * col2 + 0.1 * col3;

    gl_FragColor = color;
}