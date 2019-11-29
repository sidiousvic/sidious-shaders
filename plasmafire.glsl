<div id="container"></div>
<script id="vertexShader" type="x-shader/x-vertex">

varying vec2 vUv;
varying vec3 v_position;

void main() {
  v_position = position;
  vUv = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}
</script>
<script id="fragmentShader" type="x-shader/x-fragment">
// varyings
varying vec2 vUv;
varying vec3 v_position;
// uniforms
uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform sampler2D u_tex;
uniform float u_time;
  

// normalize mouse coords
vec2 mouse_norm = vec2(-0.5 + u_mouse.x/u_resolution.x, -0.5 + u_mouse.y/u_resolution.y );
  
vec2 rotate(vec2 pt, float theta) {
  float c = cos(theta);
  float s = sin(theta);
  mat2 mat = mat2(c, s, -s, c);
  return mat * pt;
}

  
//Based on http://clockworkchilli.com/blog/8_a_fire_shader_in_glsl_for_your_webgl_games

void main (void)
{
  vec2 noise = vec2(0.0);
  float time = u_time;
  vec2 rotvUv = rotate(vUv, 0.5);

  // Generate noisy x value
  vec2 uv = vec2(rotvUv.x*1.4 + 0.01, fract(vUv.y - time*0.69));
  noise.x = (texture2D(u_tex, uv).w-0.5)*2.0;
  uv = vec2(rotvUv.x*0.5 - 0.033, fract(vUv.y*2.0 - time*0.12));
  noise.x += (texture2D(u_tex, uv).w-0.5)*2.0;
  uv = vec2(rotvUv.x*0.94 + 0.02, fract(vUv.y*3.0 - time*0.61));
  noise.x += (texture2D(u_tex, uv).w-0.5)*2.0;
  
  // Generate noisy y value
  uv = vec2(rotvUv.x*0.7 - 0.01, fract(vUv.y - time*0.27));
  noise.y = (texture2D(u_tex, uv).w-0.5)*2.0;
  uv = vec2(rotvUv.x*0.45 + 0.033, fract(vUv.y*1.9 - time*0.61));
  noise.y = (texture2D(u_tex, uv).w-0.5)*2.0;
  uv = vec2(vUv.x*0.8 - 0.02, fract(vUv.y*2.5 - time*0.51));
  noise.y += (texture2D(u_tex, uv).w-0.5)*2.0;
  
  noise = clamp(noise, -1.0, 1.0);
  
  float perturb = (1.0 - vUv.y) * 0.35 + 0.02;
  noise = (noise * perturb) + vUv - 0.2;

  vec4 color = texture2D(u_tex, noise);
  color = vec4(color.r*2.0, color.g, (color.g/color.r)*sin(vUv.x), 1.0);
  noise = clamp(noise, 0.05, 7.0);
  // color.a = texture2D(u_tex, noise).b*2.0;
  // color.a = color.a*texture2D(u_tex, vUv).b;

  gl_FragColor = color;
} 
</script>

// shader uniforms in three.js
const uniforms = {
  u_mouse: { value: { x: window.innerWidth / 2, y: window.innerHeight / 2 } },
  u_resolution: { value: { x: window.innerWidth, y: window.innerHeight } },
  u_time: { value: 0.0 },
  u_color: { value: new THREE.Color(0xFF0000) }
}