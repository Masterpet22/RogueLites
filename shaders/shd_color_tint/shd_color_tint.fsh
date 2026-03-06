// Fragment Shader — Color Tint (tinte elemental)
// Uniforms:
//   u_tint_color : vec4  — color del tinte (r,g,b,a)
//   u_tint_mix   : float — 0 = sin tinte, 1 = tinte completo
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4  u_tint_color;
uniform float u_tint_mix;

void main()
{
    vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);
    vec3 tinted = mix(tex.rgb, tex.rgb * u_tint_color.rgb, u_tint_mix);
    gl_FragColor = vec4(tinted, tex.a * u_tint_color.a) * v_vColour;
}
