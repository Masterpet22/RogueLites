// Fragment Shader — Aura de energía (pulsación de brillo en contorno)
// Uniforms:
//   u_aura_color     : vec4  — color del aura (r,g,b,a)
//   u_aura_intensity : float — intensidad pulsante 0..1
//   u_aura_radius    : float — grosor del aura en texels (1..4)
//   u_texel_size     : vec2  — 1.0/texWidth, 1.0/texHeight
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4  u_aura_color;
uniform float u_aura_intensity;
uniform float u_aura_radius;
uniform vec2  u_texel_size;

void main()
{
    vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // Muestrear alpha expandido para detectar zona de aura
    float max_a = 0.0;
    for (float x = -2.0; x <= 2.0; x += 1.0) {
        for (float y = -2.0; y <= 2.0; y += 1.0) {
            vec2 off = vec2(x, y) * u_texel_size * u_aura_radius;
            float d = length(vec2(x, y));
            if (d > 0.0 && d <= 2.5) {
                max_a = max(max_a, texture2D(gm_BaseTexture, v_vTexcoord + off).a);
            }
        }
    }
    
    // Aura en zona transparente adyacente al sprite
    float aura_mask = max_a * (1.0 - tex.a) * u_aura_intensity;
    vec4 aura_px = vec4(u_aura_color.rgb, aura_mask * u_aura_color.a);
    
    // Sprite sobre aura — el sprite también recibe un leve brillo
    vec3 sprite_glow = tex.rgb + u_aura_color.rgb * u_aura_intensity * 0.3 * tex.a;
    vec4 sprite_px = vec4(sprite_glow, tex.a) * v_vColour;
    
    gl_FragColor = mix(aura_px, sprite_px, tex.a);
}
