// Fragment Shader — Aberración cromática (desplazamiento RGB para súper)
// Uniforms:
//   u_chrom_offset : float — desplazamiento en texels (ej. 0.005)
//   u_chrom_angle  : float — ángulo de separación en radianes
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_chrom_offset;
uniform float u_chrom_angle;

void main()
{
    vec2 dir = vec2(cos(u_chrom_angle), sin(u_chrom_angle)) * u_chrom_offset;
    
    float r = texture2D(gm_BaseTexture, v_vTexcoord + dir).r;
    vec4 center = texture2D(gm_BaseTexture, v_vTexcoord);
    float g = center.g;
    float b = texture2D(gm_BaseTexture, v_vTexcoord - dir).b;
    
    gl_FragColor = vec4(r, g, b, center.a) * v_vColour;
}
