/// CREATE - obj_control_ui_combate

control_combate = instance_find(obj_control_combate, 0);

// Sistema de pausa
pausado = false;
pausa_opcion = 0; // 0 = Reanudar, 1 = Salir

// Feedback visual botón Súper (cuando no está disponible)
super_deny_timer = 0;     // frames restantes de feedback
super_deny_shake = 0;     // offset de shake actual

// Timer para efectos de escenario (elite / jefe)
arena_fx_timer = 0;