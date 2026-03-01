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

        // ══════════════════════════════════════════════════
        //  OBJETOS RÚNICOS
        //  Se equipan antes del combate (máx 1).
        //  Se aplican automáticamente al iniciar combate.
        //  Desaparecen al terminar el combate (gane o pierda).
        //  Cada uno ofrece una VENTAJA significativa + DESVENTAJA.
        // ══════════════════════════════════════════════════

        case "Runa de Furia":
            return {
                descripcion: "+30% daño infligido, pero -20% vida máxima.",
                tipo: "runico",
                efecto: "runa_furia",
                ventaja: "+30% daño",
                desventaja: "-20% vida máxima",
                precio: 200,
                precio_venta: 60,
            };

        case "Runa de Fortaleza":
            return {
                descripcion: "+40% vida máxima, pero -25% daño infligido.",
                tipo: "runico",
                efecto: "runa_fortaleza",
                ventaja: "+40% HP",
                desventaja: "-25% daño",
                precio: 200,
                precio_venta: 60,
            };

        case "Runa de Celeridad":
            return {
                descripcion: "+50% velocidad, pero -30% defensa.",
                tipo: "runico",
                efecto: "runa_celeridad",
                ventaja: "+50% velocidad",
                desventaja: "-30% defensa",
                precio: 180,
                precio_venta: 55,
            };

        case "Runa del Ultimo Aliento":
            return {
                descripcion: "Si tu vida llega a 0, sobrevives una vez con 1 HP. Tu primer ataque del combate hace 0 daño.",
                tipo: "runico",
                efecto: "runa_ultimo_aliento",
                ventaja: "Sobrevive golpe letal (1 vez)",
                desventaja: "Primer ataque hace 0",
                precio: 300,
                precio_venta: 90,
            };

        case "Runa Vampirica":
            return {
                descripcion: "Cura 15% del daño infligido como vida. La esencia se genera un 40% más lento.",
                tipo: "runico",
                efecto: "runa_vampirica",
                ventaja: "15% lifesteal",
                desventaja: "-40% gen. esencia",
                precio: 250,
                precio_venta: 75,
            };

        case "Runa de Cristal":
            return {
                descripcion: "+50% daño infligido y +50% daño recibido. Alto riesgo, alta recompensa.",
                tipo: "runico",
                efecto: "runa_cristal",
                ventaja: "+50% daño",
                desventaja: "+50% daño recibido",
                precio: 250,
                precio_venta: 75,
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

/// @function scr_lista_runicos_disponibles()
/// @description Retorna un array con los nombres de todos los objetos rúnicos.
function scr_lista_runicos_disponibles() {
    return [
        "Runa de Furia",
        "Runa de Fortaleza",
        "Runa de Celeridad",
        "Runa del Ultimo Aliento",
        "Runa Vampirica",
        "Runa de Cristal",
    ];
}
