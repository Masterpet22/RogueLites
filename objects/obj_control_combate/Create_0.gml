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

// 2b. MODO TORRE: aplicar multiplicador de HP al enemigo
if (variable_struct_exists(control_juego, "modo_torre") && control_juego.modo_torre) {
    var _mult = control_juego.torre_hp_mult;
    personaje_enemigo.vida_max    = round(personaje_enemigo.vida_max * _mult);
    personaje_enemigo.vida_actual = personaje_enemigo.vida_max;
    personaje_enemigo.vida_visual = personaje_enemigo.vida_max;
    show_debug_message("🏰 Torre HP mult: x" + string(_mult) + " → HP enemigo: " + string(personaje_enemigo.vida_max));
}

// 2b2. MODO CAMINO: aplicar multiplicador de HP al enemigo
if (variable_struct_exists(control_juego, "modo_camino") && control_juego.modo_camino) {
    var _mult_c = control_juego.camino_hp_mult;
    personaje_enemigo.vida_max    = round(personaje_enemigo.vida_max * _mult_c);
    personaje_enemigo.vida_actual = personaje_enemigo.vida_max;
    personaje_enemigo.vida_visual = personaje_enemigo.vida_max;
    show_debug_message("⚔️ Camino HP mult: x" + string(_mult_c) + " → HP enemigo: " + string(personaje_enemigo.vida_max));
}

// 2c. MODO TORRE: restaurar HP del jugador del piso anterior
if (variable_struct_exists(control_juego, "modo_torre") && control_juego.modo_torre) {
    if (instance_exists(obj_control_torre) && obj_control_torre.torre_pj_vida_max > 0) {
        // Mantener HP del piso anterior (esencia se resetea)
        personaje_jugador.vida_max    = obj_control_torre.torre_pj_vida_max;
        personaje_jugador.vida_actual = obj_control_torre.torre_pj_vida_actual;
        personaje_jugador.esencia     = 0; // Reset esencia cada piso
        show_debug_message("🏰 Torre HP restaurado: " + string(personaje_jugador.vida_actual) + "/" + string(personaje_jugador.vida_max));
    }
}

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

// 6. Runa equipada — aplicar modificadores de stats al jugador
runa_activa = "";
runa_ultimo_aliento_disponible = false;
runa_primer_ataque = false;
runa_vampirica = false;
runa_cristal = false;
runa_fortaleza = false;

if (instance_exists(control_juego)
    && variable_struct_exists(control_juego, "runa_equipada")
    && control_juego.runa_equipada != "") {

    runa_activa = control_juego.runa_equipada;
    var _pj = personaje_jugador;

    switch (runa_activa) {
        case "Runa de Furia":
            // +30% ataque, -20% vida máx
            _pj.ataque_base = round(_pj.ataque_base * 1.30);
            _pj.vida_max    = round(_pj.vida_max * 0.80);
            _pj.vida_actual = min(_pj.vida_actual, _pj.vida_max);
            break;

        case "Runa de Fortaleza":
            // +40% vida máx, -25% daño infligido (flag)
            _pj.vida_max    = round(_pj.vida_max * 1.40);
            _pj.vida_actual = _pj.vida_max;
            runa_fortaleza  = true;
            break;

        case "Runa de Celeridad":
            // +50% velocidad, -30% defensa
            _pj.velocidad     = round(_pj.velocidad * 1.50);
            _pj.defensa_base  = round(_pj.defensa_base * 0.70);
            break;

        case "Runa del Ultimo Aliento":
            // Sobrevive 1 golpe letal (una vez), primer ataque hace 0 daño
            runa_ultimo_aliento_disponible = true;
            runa_primer_ataque = true;
            break;

        case "Runa Vampirica":
            // 15% lifesteal, -40% generación de esencia
            runa_vampirica = true;
            break;

        case "Runa de Cristal":
            // +50% daño infligido Y recibido
            runa_cristal = true;
            break;
    }

    show_debug_message("Runa activa: " + runa_activa);
}

// 7. Sistema de feedback visual (números flotantes, shake, flash)
scr_feedback_init();

// 8. Fondo de combate aleatorio (arena visual)
//    Si es revancha, mantener el mismo fondo anterior;
//    si no, elegir uno aleatorio y guardarlo.
combate_arena_idx = 0;
if (instance_exists(control_juego)) {
    if (variable_struct_exists(control_juego, "combate_arena_revancha")
        && control_juego.combate_arena_revancha >= 0) {
        // Revancha: mantener exactamente el mismo fondo
        combate_arena_idx = control_juego.combate_arena_revancha;
        control_juego.combate_arena_revancha = -1;  // consumir flag
    } else {
        // Nuevo combate: elegir arena aleatoria (0–4, para 5 fondos)
        combate_arena_idx = irandom(4);
    }
    // Guardar para que un reintento pueda recuperarlo
    control_juego.combate_arena_ultimo = combate_arena_idx;
}
show_debug_message("🏟 Arena de combate #" + string(combate_arena_idx));