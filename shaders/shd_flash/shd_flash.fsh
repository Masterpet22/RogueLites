// Fragment Shader — Flash de color (impacto / curación)
// Uniforms:
//   u_flash_color : vec4  — color del flash (r,g,b,a)
//   u_flash_mix   : float — mezcla 0..1 (0 = normal, 1 = color sólido)
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4  u_flash_color;
uniform float u_flash_mix;

void main()
{
    vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);
    vec3 mixed = mix(tex.rgb, u_flash_color.rgb, u_flash_mix);
    gl_FragColor = vec4(mixed, tex.a) * v_vColour;
}
