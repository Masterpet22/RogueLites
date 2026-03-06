// Fragment Shader — Shockwave (onda de choque radial)
// Se aplica a una surface/fondo completo
// Uniforms:
//   u_wave_center   : vec2  — centro de la onda en UV (0..1)
//   u_wave_radius   : float — radio actual de la onda (0..1)
//   u_wave_width    : float — grosor del anillo de distorsión
//   u_wave_strength : float — fuerza de distorsión
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2  u_wave_center;
uniform float u_wave_radius;
uniform float u_wave_width;
uniform float u_wave_strength;

void main()
{
    vec2 uv = v_vTexcoord;
    vec2 delta = uv - u_wave_center;
    float dist = length(delta);
    
    // Distancia al anillo de la onda
    float ring_dist = abs(dist - u_wave_radius);
    
    if (ring_dist < u_wave_width) {
        // Dentro del anillo → distorsionar UV
        float factor = 1.0 - (ring_dist / u_wave_width);
        factor = factor * factor; // suavizar
        vec2 dir = normalize(delta);
        uv += dir * factor * u_wave_strength;
    }
    
    gl_FragColor = texture2D(gm_BaseTexture, uv) * v_vColour;
}
