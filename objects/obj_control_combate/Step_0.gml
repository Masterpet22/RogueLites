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
    cds[_indice] = round(room_speed * 0.5);
}


// INPUT HABILIDADES JUGADOR

// Slot 0 → ESPACIO
if (keyboard_check_pressed(vk_space)) {
    scr_usar_habilidad_indice(personaje_jugador, personaje_enemigo, 0);
}

// Slot 1 → Q (solo funcionará si el arma tiene 2 habilidades)
if (keyboard_check_pressed(ord("Q"))) {
    scr_usar_habilidad_indice(personaje_jugador, personaje_enemigo, 1);
}

// Slot 2 → W (para armas R3)
if (keyboard_check_pressed(ord("W"))) {
    scr_usar_habilidad_indice(personaje_jugador, personaje_enemigo, 2);
}



// 3. IA corregida: Todo dentro del condicional de tiempo y vida
if (enemigo_cd_ataque <= 0 && personaje_enemigo.vida_actual > 0 && personaje_jugador.vida_actual > 0) {
    
    var hab_enemigo = personaje_enemigo.habilidad_basica;
    scr_ejecutar_habilidad(personaje_enemigo, personaje_jugador, hab_enemigo);

    // Reiniciar el timer
    enemigo_cd_ataque = round(room_speed * 0.75);
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

            // --- RECOMPENSA RESTAURADA ---
            // Asegúrate de que el objeto global de control exista
            if (instance_exists(obj_control_juego)) { 

                var mat = personaje_enemigo.material_drop; // Ejemplo: "Fragmento Igneo"
                var cantidad_drop = irandom_range(1, 3); 

                // Llamada al script de inventario
                scr_inventario_agregar_material(obj_control_juego, mat, cantidad_drop);

                show_debug_message("¡Ganaste! Recompensa: " + string(cantidad_drop) + " x " + string(mat));
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