#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

// Ambient page background: a slow-drifting brand glow, a dot grid that
// parallaxes with scroll and lights up around the cursor, and a static
// film grain. Colors come in as uniforms so the same shader serves both
// themes.
uniform vec2 uSize;
uniform float uTime;
uniform vec2 uMouse;
uniform float uMouseStrength;
uniform float uScroll;
uniform vec4 uBg;
uniform vec4 uGrid;
uniform vec4 uBrand;

out vec4 fragColor;

float hash(vec2 p) {
  p = fract(p * vec2(123.34, 456.21));
  p += dot(p, p + 45.32);
  return fract(p.x * p.y);
}

float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  f = f * f * (3.0 - 2.0 * f);
  float a = hash(i);
  float b = hash(i + vec2(1.0, 0.0));
  float c = hash(i + vec2(0.0, 1.0));
  float d = hash(i + vec2(1.0, 1.0));
  return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void main() {
  vec2 frag = FlutterFragCoord().xy;
  vec2 uv = frag / uSize;
  float aspect = uSize.x / uSize.y;
  vec3 col = uBg.rgb;

  // Drifting glow, anchored near the top-right and slowly wandering.
  float t = uTime * 0.05;
  vec2 q = vec2(uv.x * aspect, uv.y);
  float n = noise(q * 1.8 + vec2(t, -t * 0.7)) * 0.6 +
            noise(q * 3.6 - vec2(t * 1.3, t)) * 0.4;
  vec2 c1 = vec2(0.80 + 0.06 * sin(t * 3.0), 0.12 + 0.05 * cos(t * 2.3));
  float d1 = length((uv - c1) * vec2(aspect, 1.0));
  float glow = smoothstep(0.85, 0.0, d1) * (0.45 + 0.55 * n);
  col = mix(col, uBrand.rgb, glow * uBrand.a);

  // Cursor spotlight.
  float spot = uMouseStrength * smoothstep(280.0, 0.0, length(frag - uMouse));
  col = mix(col, uBrand.rgb, spot * uBrand.a * 0.35);

  // Dot grid, drifting at a quarter of the scroll speed for depth.
  float cell = 28.0;
  vec2 g = vec2(frag.x, frag.y + uScroll * 0.25);
  vec2 gp = mod(g, cell) - cell * 0.5;
  float dotMask = smoothstep(1.4, 0.5, length(gp));
  float gridAlpha = uGrid.a * (0.45 + 2.6 * spot);
  col = mix(col, uGrid.rgb, clamp(dotMask * gridAlpha, 0.0, 1.0));

  // Static grain — takes the flat, digital edge off the background.
  col += (hash(frag) - 0.5) * 0.03;

  fragColor = vec4(col, 1.0);
}
