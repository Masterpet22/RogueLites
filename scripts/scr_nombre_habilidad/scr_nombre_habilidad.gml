/// scr_nombre_habilidad(id_habilidad) -> string
function scr_nombre_habilidad(_id) {

    switch (_id) {

        case "ataque_basico":
            return "Golpe";

        case "ataque_fuego_basico":
            return "Golpe Ígneo";
			
			case "ataque_fuego_mejorado": return "Golpe Ígneo+";
case "explosion_carmesi":    return "Expl.Carm.";

        // Añade más nombres según vayas creando habilidades
    }

    return string(_id); // fallback: id crudo
}