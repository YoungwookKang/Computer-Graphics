#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

uniform float cx;
uniform float cy;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

vec2 complexPow4(vec2 z) {
  return vec2(
  z.x * z.x * z.x * z.x - 6.0 * z.x * z.x * z.y * z.y + z.y * z.y * z.y * z.y,
  4.0 * z.x * z.x * z.x * z.y - 4.0 * z.x * z.y * z.y * z.y
  );
}

void main() {
  vec2 z = vertTexCoord.xy * 2.5 - vec2(1.25, 1.25);
  vec2 c = vec2(cx, cy);

  const float escapeRadius = 400.0;
  const int maxIterations = 20;
  int iterations = 0;

  for (int i = 0; i < maxIterations; i++) {
    z = complexPow4(z) + c;

    if (dot(z, z) > escapeRadius) {
      break;
    }

    iterations++;
  }

  vec3 backgroundColor = vec3(1.0, 0.0, 0.0);

  if (iterations == maxIterations) {
    gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
  } else {
    gl_FragColor = vec4(backgroundColor, 1.0);
  }
}
