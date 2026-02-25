/// scr_ejecutar_habilidad(atacante, defensor, id_habilidad)
function scr_ejecutar_habilidad(_atacante, _defensor, _id) {

    switch (_id) {

        case "ataque_basico":
        {
			scr_activar_pasiva_afinidad(_atacante, "uso_habilidad");
            var dano = scr_calcular_dano(_atacante, _defensor);

            _defensor.vida_actual = max(0, _defensor.vida_actual - dano);
			scr_activar_pasiva_afinidad(_defensor, "recibir_dano");

            // Cargar un poco de esencia
            _atacante.esencia += 10;
            if (_atacante.esencia > _atacante.esencia_llena) {
                _atacante.esencia = _atacante.esencia_llena;
            }

            show_debug_message(_atacante.nombre + " hace " + string(dano) + " de daño básico a " + _defensor.nombre);
        }
        break;


       case "ataque_fuego_basico":
		{
			var dano_base = scr_calcular_dano(_atacante, _defensor);
			var bonus_fuego = round(_atacante.poder_elemental * 0.5);
			var dano_total = dano_base + bonus_fuego;

			_defensor.vida_actual = max(0, _defensor.vida_actual - dano_total);

			// 🔥 Aplicar quemadura: dura 3 segundos, potencia extra según poder elemental
			var duracion = round(room_speed * 3);
			var pot_extra = round(_atacante.poder_elemental * 0.4);

			scr_aplicar_estado(_defensor, "quemadura_fuego", duracion, pot_extra);

			// ESENCIA
			_atacante.esencia += 10;
			if (_atacante.esencia > _atacante.esencia_llena) {
			    _atacante.esencia = _atacante.esencia_llena;
			}

			show_debug_message(
			    _atacante.nombre + " usa ATAQUE DE FUEGO y hace " 
			    + string(dano_total) + " daño directo y aplica QUEMADURA."
			);
		}
		break;
		case "ataque_fuego_mejorado":
{
    var dano_base = scr_calcular_dano(_atacante, _defensor);
    var bonus_fuego = round(_atacante.poder_elemental * 0.8);
    var dano_total = dano_base + bonus_fuego;

    _defensor.vida_actual = max(0, _defensor.vida_actual - dano_total);

    // Quemadura más fuerte que Filo Ígneo
    var dur = round(room_speed * 3);
    var pot = round(_atacante.poder_elemental * 0.6);
    scr_aplicar_estado(_defensor, "quemadura_fuego", dur, pot);

    _atacante.esencia += 12;

    show_debug_message(
        _atacante.nombre + " usa ATAQUE FUEGO MEJORADO causando "
        + string(dano_total) + " y aplicando quemadura potente."
    );
}
break;
case "explosion_carmesi":
{
    var dano_base = scr_calcular_dano(_atacante, _defensor);
    var bonus_explosion = round(_atacante.poder_elemental * 1.2);
    var dano_total = dano_base + bonus_explosion;

    _defensor.vida_actual = max(0, _defensor.vida_actual - dano_total);

    // Quemadura ultra fuerte
    var dur = round(room_speed * 4);
    var pot = round(_atacante.poder_elemental * 0.8);
    scr_aplicar_estado(_defensor, "quemadura_fuego", dur, pot);

    _atacante.esencia += 20;

    show_debug_message(
        _atacante.nombre + " lanza EXPLOSIÓN CARMESÍ causando "
        + string(dano_total) + " + quemadura intensa!"
    );
}
break;


        default:
            show_debug_message("Habilidad no implementada: " + string(_id));
        break;
    }
}