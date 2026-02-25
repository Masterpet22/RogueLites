/// CREATE — obj_control_combate

// Referencia al controlador global de juego
control_juego = instance_find(obj_control_juego, 0);

// Determinar arma inicial del jugador desde el PERFIL
var arma_inicial = "Hoja Rota"; // fallback seguro

if (instance_exists(control_juego)) {
    var perfil = scr_get_perfil_activo(control_juego);
    if (perfil.arma_equipada != undefined) {
        arma_inicial = perfil.arma_equipada;
    }
}

// 1. Crear personaje del jugador usando el arma del perfil
personaje_jugador = scr_crear_personaje_combate(
    "Kael",
    true,
    "Vanguardia",
    "Fuego",
    arma_inicial
);

// 2. Crear enemigo
var enemigo_nombre = control_juego.enemigo_seleccionado;
personaje_enemigo = scr_crear_enemigo_combate(enemigo_nombre);

// 3. Control de combate
combate_terminado = false;
ganador = "";
enemigo_cd_ataque = room_speed;