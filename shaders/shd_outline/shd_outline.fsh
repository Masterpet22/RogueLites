// Fragment Shader — Outline (borde sólido alrededor del sprite)
// Uniforms:
//   u_outline_color : vec4  — color del borde (r,g,b,a)
//   u_texel_size    : vec2  — 1.0/texWidth, 1.0/texHeight
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec4 u_outline_color;
uniform vec2 u_texel_size;

void main()
{
    vec4 tex = texture2D(gm_BaseTexture, v_vTexcoord);
    
    if (tex.a > 0.1) {
        // Pixel visible → color normal
        gl_FragColor = tex * v_vColour;
    } else {
        // Pixel transparente → detectar si hay un pixel opaco adyacente
        float a_up    = texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0, -u_texel_size.y)).a;
        float a_down  = texture2D(gm_BaseTexture, v_vTexcoord + vec2(0.0,  u_texel_size.y)).a;
        float a_left  = texture2D(gm_BaseTexture, v_vTexcoord + vec2(-u_texel_size.x, 0.0)).a;
        float a_right = texture2D(gm_BaseTexture, v_vTexcoord + vec2( u_texel_size.x, 0.0)).a;
        
        float border = max(max(a_up, a_down), max(a_left, a_right));
        
        if (border > 0.1) {
            gl_FragColor = u_outline_color;
        } else {
            gl_FragColor = vec4(0.0);
        }
    }
}
