/// @function scr_datos_objetos(_nombre)
/// @description Retorna un struct con los datos del objeto/consumible especificado.
function scr_datos_objetos(_nombre) {

    switch (_nombre) {

        case "Pocion Basica":
            return {
                descripcion: "Restaura 30 puntos de vida.",
                tipo: "consumible",
                efecto: "curar_vida",
                valor_efecto: 30,
                precio: 50,
                precio_venta: 15,
            };

        case "Pocion Media":
            return {
                descripcion: "Restaura 80 puntos de vida.",
                tipo: "consumible",
                efecto: "curar_vida",
                valor_efecto: 80,
                precio: 150,
                precio_venta: 45,
            };

        case "Elixir de Esencia":
            return {
                descripcion: "Restaura 50% de la barra de esencia.",
                tipo: "consumible",
                efecto: "restaurar_esencia",
                valor_efecto: 50,
                precio: 120,
                precio_venta: 35,
            };

        case "Tonico de Ataque":
            return {
                descripcion: "Aumenta el ataque en +5 durante el combate actual.",
                tipo: "consumible",
                efecto: "buff_ataque",
                valor_efecto: 5,
                precio: 100,
                precio_venta: 30,
            };

        case "Tonico de Defensa":
            return {
                descripcion: "Aumenta la defensa en +5 durante el combate actual.",
                tipo: "consumible",
                efecto: "buff_defensa",
                valor_efecto: 5,
                precio: 100,
                precio_venta: 30,
            };

        default:
            show_error("Objeto no encontrado: " + string(_nombre), true);
            return undefined;
    }
}

/// @function scr_lista_objetos_disponibles()
/// @description Retorna un array con los nombres de todos los objetos registrados.
function scr_lista_objetos_disponibles() {
    return [
        "Pocion Basica",
        "Pocion Media",
        "Elixir de Esencia",
        "Tonico de Ataque",
        "Tonico de Defensa",
    ];
}
