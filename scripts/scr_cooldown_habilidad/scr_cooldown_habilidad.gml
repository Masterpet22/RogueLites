/// scr_cooldown_habilidad(id_habilidad) -> frames
function scr_cooldown_habilidad(_id) {

    switch (_id) {

        case "ataque_basico":
            return round(room_speed * 0.4); // 0.4 s

        case "ataque_fuego_basico":
            return round(room_speed * 0.6); // un poco más lento
			
case "ataque_fuego_mejorado":
    return round(room_speed * 0.8); // 0.8 segundos

case "explosion_carmesi":
    return round(room_speed * 2.5); // 2.5 segundos de cooldown
        // Aquí irás añadiendo más habilidades (R2, R3, etc.)
    }

    // Por defecto, sin cooldown
    return 0;
}