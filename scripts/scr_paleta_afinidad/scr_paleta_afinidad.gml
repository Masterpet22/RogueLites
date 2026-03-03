/// @file scr_paleta_afinidad.gml
/// @description  Sistema de paleta visual por afinidad.
///   Cada afinidad tiene 3 colores: dominante, secundario, energía (glow).
///   Usado para: flash elemental, glow de sprites, partículas, aura de esencia.

/// scr_paleta_afinidad(nombre_afinidad)
/// Devuelve un struct con los 3 colores de la afinidad.
/// @param {string} _afi  "Fuego"|"Agua"|"Planta"|"Rayo"|"Tierra"|"Sombra"|"Luz"|"Arcano"|"Neutra"
/// @returns {struct}  { dominante, secundario, energia }
function scr_paleta_afinidad(_afi) {

    switch (_afi) {

        case "Fuego":
            return {
                dominante:  make_color_rgb(139, 26, 26),   // #8B1A1A rojo oscuro
                secundario: make_color_rgb(204, 85, 0),    // #CC5500 naranja
                energia:    make_color_rgb(255, 215, 0),   // #FFD700 amarillo incandescente
            };

        case "Agua":
            return {
                dominante:  make_color_rgb(0, 51, 102),    // #003366 azul profundo
                secundario: make_color_rgb(176, 224, 230), // #B0E0E6 azul hielo
                energia:    make_color_rgb(240, 248, 255), // #F0F8FF blanco escarcha
            };

        case "Planta":
            return {
                dominante:  make_color_rgb(34, 139, 34),   // #228B22 verde bosque
                secundario: make_color_rgb(50, 205, 50),   // #32CD32 verde lima
                energia:    make_color_rgb(173, 255, 47),  // #ADFF2F amarillo esporas
            };

        case "Rayo":
            return {
                dominante:  make_color_rgb(0, 128, 255),   // #0080FF azul eléctrico
                secundario: make_color_rgb(123, 45, 142),  // #7B2D8E violeta
                energia:    make_color_rgb(255, 255, 255), // #FFFFFF blanco brillante
            };

        case "Tierra":
            return {
                dominante:  make_color_rgb(139, 115, 85),  // #8B7355 marrón tierra
                secundario: make_color_rgb(0, 168, 107),   // #00A86B verde jade
                energia:    make_color_rgb(194, 178, 128), // #C2B280 arena dorada
            };

        case "Sombra":
            return {
                dominante:  make_color_rgb(13, 13, 13),    // #0D0D0D negro puro
                secundario: make_color_rgb(48, 25, 52),    // #301934 violeta oscuro
                energia:    make_color_rgb(204, 153, 255), // #CC99FF púrpura pálido
            };

        case "Luz":
            return {
                dominante:  make_color_rgb(255, 255, 240), // #FFFFF0 blanco marfil
                secundario: make_color_rgb(255, 215, 0),   // #FFD700 dorado
                energia:    make_color_rgb(255, 191, 0),   // #FFBF00 ámbar cálido
            };

        case "Arcano":
            return {
                dominante:  make_color_rgb(75, 0, 130),    // #4B0082 púrpura profundo
                secundario: make_color_rgb(0, 255, 255),   // #00FFFF cian
                energia:    make_color_rgb(255, 0, 255),   // #FF00FF magenta brillante
            };

        case "Neutra":
        default:
            return {
                dominante:  make_color_rgb(128, 128, 128), // gris neutro
                secundario: make_color_rgb(192, 192, 192), // gris claro
                energia:    make_color_rgb(255, 255, 255), // blanco
            };
    }
}


/// scr_color_energia_afinidad(nombre_afinidad)
/// Atajo: devuelve solo el color de energía/glow de la afinidad.
/// @param {string} _afi
/// @returns {real}  color GM
function scr_color_energia_afinidad(_afi) {
    var _p = scr_paleta_afinidad(_afi);
    return _p.energia;
}


/// scr_color_dominante_afinidad(nombre_afinidad)
/// Atajo: devuelve solo el color dominante de la afinidad.
/// @param {string} _afi
/// @returns {real}  color GM
function scr_color_dominante_afinidad(_afi) {
    var _p = scr_paleta_afinidad(_afi);
    return _p.dominante;
}
