<div id="container"></div>
<script id="vertexShader" type="x-shader/x-vertex">

varying vec2 v_uv;
varying vec3 v_position;

void main() {
  v_position = position;
  v_uv = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);

}
</script>
<script id="fragmentShader" type="x-shader/x-fragment">
// varyings
varying vec2 v_uv;
varying vec3 v_position;
uniform vec2 u_mouse;
// uniforms
uniform vec2 u_resolution;
uniform vec3 u_color;
uniform float u_time;

// normalize mouse coords
vec2 mouse_norm = vec2(-0.5 + u_mouse.x/u_resolution.x, -0.5 + u_mouse.y/u_resolution.y );
// getRotationMatrix
mat2 getRotationMatrix(float theta) {
  float s = sin(theta);
  float c = cos(theta);
  return mat2(c, s, -s, c);
}
// getScaleMatrix
mat2 getScaleMatrix(float scale) {
  return mat2(scale, 0, 0, scale);
}

// 2D Random
float random (vec2 st) {
    return fract(sin(dot(st, vec2(12.9898,78.233)))
                 * 43758.5453123);
}
// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float noise (vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smooth Interpolation

    // Cubic Hermine Curve.  Same as SmoothStep()
    vec2 u = f*f*(3.0-2.0*f);
    // u = smoothstep(0.,1.,f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

void main() {
    vec2 st = v_uv;

    // Scale the coordinate system to see
    // some noise in action
    vec2 pos = vec2(st*100.0);
    pos.y -= u_time * 80.0;

    // Use the noise function
    float n = noise(pos); 
    //n = smoothstep(0.4, 0.6, n);
  
    // mix red and yellow
    vec3 color = mix(vec3(1.0, 1.0, 0.0), vec3(1.0, 0.0, 0.0), n);

    gl_FragColor = vec4(color, 1.0);
} 
</script>

// shader uniforms in three.js
const uniforms = {
  u_mouse: { value: { x: window.innerWidth / 2, y: window.innerHeight / 2 } },
  u_resolution: { value: { x: window.innerWidth, y: window.innerHeight } },
  u_time: { value: 0.0 },
  u_color: { value: new THREE.Color(0xFF0000) }
}
