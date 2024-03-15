// edges.frag
#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXLIGHT_SHADER

uniform sampler2D my_texture;
uniform float cx;
uniform float cy;
uniform float time;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

float grayscale(vec4 color) {
  return 0.299 * color.r + 0.587 * color.g + 0.114 * color.b;
}

void main() {
  vec2 onePixel = vec2(1.0 / textureSize(my_texture, 0).x, 1.0 / textureSize(my_texture, 0).y);

  float centerIntensity = grayscale(texture2D(my_texture, vertTexCoord.st));

  float topIntensity = grayscale(texture2D(my_texture, vertTexCoord.st + vec2(0.0, onePixel.y)));
  float bottomIntensity = grayscale(texture2D(my_texture, vertTexCoord.st - vec2(0.0, onePixel.y)));
  float rightIntensity = grayscale(texture2D(my_texture, vertTexCoord.st + vec2(onePixel.x, 0.0)));
  float leftIntensity = grayscale(texture2D(my_texture, vertTexCoord.st - vec2(onePixel.x, 0.0)));

  float laplacian = 0.25 * (topIntensity + bottomIntensity + rightIntensity + leftIntensity) - centerIntensity;

  float edgeIntensity = 0.5 + 10.0 * laplacian;

  vec2 circleCenter = vec2(cx + 0.5 * sin(time), cy + 0.5 * cos(time));
  float radius = 0.2; // Radius of the circle

  if (distance(vertTexCoord.st, circleCenter) < radius) {
    gl_FragColor = vec4(edgeIntensity, edgeIntensity, edgeIntensity, 1.0);
  } else {
    gl_FragColor = texture2D(my_texture, vertTexCoord.st);
  }
}
