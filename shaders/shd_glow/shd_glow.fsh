// Fragment Shader — Glow elemental (brillo radial alrededor del sprite)
// Uniforms:
//   u_glow_color     : vec4  — color del glow (r,g,b,a)
//   u_glow_intensity : float — intensidad 0..1
//   u_texel_size     : vec2  — 1.0/texWidth, 1.0/texHeight
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4  u_glow_color;
uniform float u_glow_intensity;
uniform vec2  u_texel_size;

void main()
{
    vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // Muestrear alpha en 8 direcciones para detectar borde
    float a_sum = 0.0;
    for (float x = -1.0; x <= 1.0; x += 1.0) {
        for (float y = -1.0; y <= 1.0; y += 1.0) {
            if (x == 0.0 && y == 0.0) continue;
            vec2 offset = vec2(x, y) * u_texel_size * 2.0;
            a_sum += texture2D(gm_BaseTexture, v_vTexcoord + offset).a;
        }
    }
    
    // Si hay alpha alrededor pero el pixel actual es transparente → glow
    float glow = clamp(a_sum / 8.0, 0.0, 1.0) * (1.0 - tex.a) * u_glow_intensity;
    
    vec4 glow_px = vec4(u_glow_color.rgb, glow * u_glow_color.a);
    
    // Mezclar: sprite encima del glow
    gl_FragColor = mix(glow_px, tex * v_vColour, tex.a);
}
