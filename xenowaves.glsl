<div id="container"></div>
<script id="vertexShader" type="x-shader/x-vertex">

varying vec2 v_uv;
varying vec3 v_position;

void main() {	
  v_uv = uv;
  v_position = position;
  gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
}
  
</script>
<script id="fragmentShader" type="x-shader/x-fragment">
#define PI 3.141592653589
varying vec2 v_uv;
varying vec3 v_position;
uniform vec2 u_mouse;
uniform vec2 u_resolution;
uniform vec3 u_color;
uniform float u_time;
uniform float u_duration;
uniform float u_twirls;

  
 // normalize mouse coords
vec2 mouse = vec2(-0.5 + u_mouse.x/u_resolution.x, -0.5 + u_mouse.y/u_resolution.y );
  
uniform sampler2D u_tex;
  
vec2 rotate(vec2 pt, float theta) {
  float c = cos(theta);
  float s = sin(theta);
  mat2 mat = mat2(c, s, -s, c);
  return mat * pt;
}
  
void main() {
  float mousexy = mouse.x * mouse.y;
  vec2 p = v_position.xy;
  float len = length(p);
  
  vec2 ripple = v_uv + p/len*0.03*cos(len*25.0-u_time*4.0) * mouse;
  float delta = (sin(mod(u_time, u_duration) * (2.0 * PI / u_duration)) + 1.0)/ 2.0;
  vec2 uv = mix(ripple, v_uv, mouse.x * mouse.y);
  vec3 color = texture2D(u_tex, uv).rgb;
  gl_FragColor = vec4(color, 1.0);
  
}
</script>


// shader uniforms in three.js
const uniforms = {
  u_tex: { value: new THREE.TextureLoader().load('https://i.imgur.com/yTsVzoI.jpg')},
  u_duration: { value: 8.0 },
  u_mouse: { value: { x: 1.0, y: 1.0 } },
  u_resolution: { value: { x: window.innerWidth, y: window.innerHeight } },
  u_time: { value: 0.0 },
  u_color: { value: new THREE.Color(0xFF0000) }
}