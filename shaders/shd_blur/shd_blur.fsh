// Fragment Shader — Blur Gaussiano 9-tap (horizontal + vertical combinado)
// Uniforms:
//   u_texel_size : vec2 — (1/ancho, 1/alto) de la textura
//   u_blur_amount : float — multiplicador de dispersión (0 = sin blur, 1..3 = normal)
//   u_darken : float — oscurecimiento (0 = sin oscurecer, 1 = negro total)
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 u_texel_size;
uniform float u_blur_amount;
uniform float u_darken;

void main()
{
    // Pesos gaussianos para kernel 9-tap (sigma ~2.0)
    float weight[5];
    weight[0] = 0.227027;
    weight[1] = 0.194596;
    weight[2] = 0.121621;
    weight[3] = 0.054054;
    weight[4] = 0.016216;

    vec2 offset = u_texel_size * u_blur_amount;

    // Muestra central
    vec4 result = texture2D(gm_BaseTexture, v_vTexcoord) * weight[0];

    // Muestras horizontales y verticales combinadas
    for (int i = 1; i < 5; i++) {
        float w = weight[i];
        float fi = float(i);
        // Horizontal
        result += texture2D(gm_BaseTexture, v_vTexcoord + vec2(offset.x * fi, 0.0)) * w;
        result += texture2D(gm_BaseTexture, v_vTexcoord - vec2(offset.x * fi, 0.0)) * w;
        // Vertical
        result += texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, offset.y * fi)) * w;
        result += texture2D(gm_BaseTexture, v_vTexcoord - vec2(0.0, offset.y * fi)) * w;
    }

    // Normalizar (el kernel acumula ~1.23 por dirección, ~1.47 combinado)
    result.rgb /= 1.47;

    // Oscurecimiento gradual
    result.rgb *= (1.0 - u_darken * 0.6);

    gl_FragColor = result * v_vColour;
}
