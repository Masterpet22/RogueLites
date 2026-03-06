// Fragment Shader — Desaturación (escala de grises parcial/total)
// Uniforms:
//   u_desat_amount : float — 0 = color, 1 = escala de grises completa
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_desat_amount;

void main()
{
    vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);
    float gray = dot(tex.rgb, vec3(0.299, 0.587, 0.114));
    vec3 desat = mix(tex.rgb, vec3(gray), u_desat_amount);
    gl_FragColor = vec4(desat, tex.a) * v_vColour;
}
