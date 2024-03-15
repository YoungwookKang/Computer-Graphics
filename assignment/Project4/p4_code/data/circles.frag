#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_LIGHT_SHADER

// These values come from the vertex shader
varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

bool inCircle(vec2 point, vec2 center, float radius) {
  return length(point - center) < radius;
}

void main() {
  vec4 diffuse_color = vec4 (0.0, 1.0, 1.0, 1.0);
  float diffuse = clamp(dot(vertNormal, vertLightDir), 0.0, 1.0);
  vec4 bgColor = vec4(diffuse * diffuse_color.rgb, 1.0);

  vec2 uv = vertTexCoord.xy * 2.0 - 1.0;
  vec2 center = vec2(0.0, 0.0);

  float centralRadius = 0.15;

  if (inCircle(uv, center, centralRadius)) {
    bgColor.a = 0.0;
  }


  for (int i = 0; i < 6; ++i) {
    float angle = 3.14159 * 2.0 * float(i) / 6.0;
    for (int j = 1; j <= 3; ++j) {

      vec2 spokeCenter = center + vec2(cos(angle), sin(angle)) * (centralRadius * 2.0 * float(j));
      float spokeRadius = centralRadius * (1.0 - 0.25 * float(j));

      if (inCircle(uv, spokeCenter, spokeRadius)) {
        bgColor.a = 0.0;
        break;
      }
    }
  }

  // Set the color of the fragment
  gl_FragColor = bgColor;
}
