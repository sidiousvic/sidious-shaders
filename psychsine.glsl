const vShader = `
varying vec2 v_uv;
void main() {
  v_uv = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);

}
`
const fShader = `
varying vec2 v_uv;
uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform vec3 u_color;
uniform float u_time;

const float PI = 3.1415926535897932384626433832795;

void main() {
  vec2 v = u_mouse / u_resolution;
  vec2 uv = gl_FragCoord.xy / u_resolution;
  vec3 color = vec3(sin(v.x) * v_uv.y * sin(v_uv.x) * v.x, abs(sin(u_time * sin(-v_uv.x) 
/ v_uv.y / 0.5 * v.x)), sin(uv.x) / sin(v_uv.x));
  gl_FragColor = vec4(color, 1).rgab;
}
`

// shader uniforms in three.js
const uniforms = {
  u_mouse: { value: { x: window.innerWidth, y: 1 } },
  u_resolution: { value: { x: window.innerWidth, y: window.innerHeight } },
  u_time: { value: 0.0 },
  u_color: { value: new THREE.Color(0xFF0000) }
}