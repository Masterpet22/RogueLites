/// STEP - obj_control_combate

// Si el combate terminó
if (combate_terminado)
{
    // Corregido: Ahora coincide con el comentario o usa la tecla que prefieras
    if (keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_escape))
    {
        room_goto(rm_menu);
    }
    exit;
}

// 1. Actualizar personajes (cooldowns, etc.)
scr_actualizar_personaje(personaje_jugador);
scr_actualizar_personaje(personaje_enemigo);
scr_actualizar_pasivas(personaje_jugador);
scr_actualizar_pasivas(personaje_enemigo);
scr_actualizar_estados(personaje_jugador);
scr_actualizar_estados(personaje_enemigo);

// Reducir timer del enemigo manualmente si no se hace en scr_actualizar
if (enemigo_cd_ataque > 0) enemigo_cd_ataque -= 1;


// 2. Input del jugador
/// STEP — obj_control_combate

// ... al principio ya tienes checks de combate_terminado, actualización, etc.

// Helper local para ejecutar habilidad por índice
function usar_habilidad_indice(_indice) {

    var habs = personaje_jugador.habilidades_arma;
    var cds  = personaje_jugador.habilidades_cd;

    if (!is_array(habs)) return;
    var n = array_length(habs);
    if (_indice < 0 || _indice >= n) return; // no existe esa habilidad

    // Chequear cooldown
    if (cds[_indice] > 0) return;

    var id_hab = habs[_indice];

    // Ejecutar
    scr_ejecutar_habilidad(personaje_jugador, personaje_enemigo, id_hab);

    // Cooldown simple: 0.5 s para todo (luego lo afinamos por habilidad)
    cds[_indice] = round(GAME_FPS * 0.5);
}


// INPUT HABILIDADES JUGADOR

// Slot 0 (Clase) → ESPACIO
if (keyboard_check_pressed(vk_space)) {
    scr_usar_habilidad_indice(personaje_jugador, personaje_enemigo, 0);
}

// Slot 1 (Arma hab 1) → Q
if (keyboard_check_pressed(ord("Q"))) {
    scr_usar_habilidad_indice(personaje_jugador, personaje_enemigo, 1);
}

// Slot 2 (Arma hab 2, R2+) → W
if (keyboard_check_pressed(ord("W"))) {
    scr_usar_habilidad_indice(personaje_jugador, personaje_enemigo, 2);
}

// Slot 3 (Arma hab 3, R3) → E
if (keyboard_check_pressed(ord("E"))) {
    scr_usar_habilidad_indice(personaje_jugador, personaje_enemigo, 3);
}

// SÚPER-HABILIDAD → R (requiere esencia llena)
if (keyboard_check_pressed(ord("R"))) {
    if (personaje_jugador.esencia >= personaje_jugador.esencia_llena) {
        scr_ejecutar_super(personaje_jugador, personaje_enemigo);
    }
}



// 3. IA corregida: Todo dentro del condicional de tiempo y vida
if (enemigo_cd_ataque <= 0 && personaje_enemigo.vida_actual > 0 && personaje_jugador.vida_actual > 0) {
    
    var hab_enemigo = personaje_enemigo.habilidad_basica;
    scr_ejecutar_habilidad(personaje_enemigo, personaje_jugador, hab_enemigo);

    // Reiniciar el timer
    enemigo_cd_ataque = round(GAME_FPS * 0.75);
}


// 4. Comprobar fin de combate
if (personaje_jugador.vida_actual <= 0 || personaje_enemigo.vida_actual <= 0) {

    if (!combate_terminado) { // Para que solo entre una vez
        combate_terminado = true;

        if (personaje_jugador.vida_actual <= 0 && personaje_enemigo.vida_actual <= 0) {
            ganador = "Empate";
        }
        else if (personaje_enemigo.vida_actual <= 0) {
            ganador = "Jugador";

            // --- RECOMPENSA CON PROBABILIDADES ---
            if (instance_exists(obj_control_juego)) {

                var _drops = personaje_enemigo.material_drop; // Array de { material, cant_min, cant_max, chance }
                var _log = "";

                for (var i = 0; i < array_length(_drops); i++) {
                    var _d = _drops[i];
                    var _roll = irandom(99); // 0–99

                    if (_roll < _d.chance) {
                        var _cant = irandom_range(_d.cant_min, _d.cant_max);
                        scr_inventario_agregar_material(obj_control_juego, _d.material, _cant);
                        _log += string(_cant) + "x " + _d.material + "  ";
                    }
                }

                if (_log == "") _log = "(nada extra)";
                show_debug_message("¡Ganaste! Drops: " + _log);

            } else {
                show_debug_message("ERROR: No se encontró obj_control_juego para dar la recompensa.");
            }
        }
        else {
            ganador = "Enemigo";
        }

        show_debug_message("Combate terminado. Ganador: " + ganador);
    }
}