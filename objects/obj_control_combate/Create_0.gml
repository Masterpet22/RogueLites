/// CREATE — obj_control_combate

// Semilla aleatoria por combate — asegura variación incluso si rm_boot no la refrescó
randomize();
show_debug_message("🎲 randomize() ejecutado en obj_control_combate — seed refrescado");

// Referencia al controlador global de juego
control_juego = instance_find(obj_control_juego, 0);

// Determinar datos del jugador desde el PERFIL seleccionado
var perfil = undefined;
var arma_inicial     = "Hoja Rota";
var nombre_pj        = "Kael";
var clase_pj         = "Vanguardia";
var afinidad_pj      = "Fuego";
var personalidad_pj  = "Resuelto";

if (instance_exists(control_juego)) {
    perfil = scr_get_perfil_activo(control_juego);
    if (perfil != undefined) {
        nombre_pj       = perfil.nombre;
        clase_pj        = perfil.clase;
        afinidad_pj     = perfil.afinidad;
        personalidad_pj = perfil.personalidad;
        if (perfil.arma_equipada != undefined) {
            arma_inicial = perfil.arma_equipada;
        }
    }
}

// 1. Crear personaje del jugador usando los datos del perfil seleccionado
personaje_jugador = scr_crear_personaje_combate(
    nombre_pj,
    true,
    clase_pj,
    afinidad_pj,
    arma_inicial,
    personalidad_pj
);

// 2. Crear enemigo
var enemigo_nombre = control_juego.enemigo_seleccionado;
personaje_enemigo = scr_crear_enemigo_combate(enemigo_nombre);

// 3. Control de combate
combate_terminado = false;
ganador = "";
oro_recompensa = 0;  // oro ganado al derrotar al enemigo

// 4. Sistema de notificaciones
notificaciones = [];  // array de structs { quien, texto, color, timer, alpha }

// 5. Objetos equipados para este combate (máx 3)
objetos_equipados = []; // nombres de objetos
objetos_usados   = []; // booleanos: true si ya se usó

if (instance_exists(control_juego)
    && variable_struct_exists(control_juego, "objetos_para_combate")
    && is_array(control_juego.objetos_para_combate)) {

    var _src = control_juego.objetos_para_combate;
    for (var i = 0; i < array_length(_src); i++) {
        array_push(objetos_equipados, _src[i]);
        array_push(objetos_usados, false);
    }
}
show_debug_message("Objetos equipados para combate: " + string(objetos_equipados));