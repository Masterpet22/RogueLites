/// scr_calcular_dano(atacante, defensor)
function scr_calcular_dano(_atacante, _defensor) {

    var base_ataque = _atacante.ataque_base;

	var defensa_obj = _defensor.defensa_base;
	if (variable_struct_exists(_defensor, "defensa_bonus_temp")) {
	    defensa_obj += _defensor.defensa_bonus_temp;
	}

	var dano_bruto = base_ataque - (defensa_obj * 0.5);

    // Afinidad — usa versión dual para soportar jefes con 2 afinidades
    var mult_afi = scr_multiplicador_afinidad_dual(_atacante, _defensor);

    var dano_final = dano_bruto * mult_afi;

    // Aseguramos daño mínimo y número entero
    dano_final = max(1, round(dano_final));
	
	// Pasiva de FUEGO → +20% daño (checa primaria y secundaria)
	var _atk_afi2 = variable_struct_exists(_atacante, "afinidad_secundaria") ? _atacante.afinidad_secundaria : "none";
	if (_atacante.pasiva_activa && (_atacante.afinidad == "Fuego" || _atk_afi2 == "Fuego")) {
	    dano_final = round(dano_final * 1.20);
	}

	// Pasiva de TIERRA influye en defensa (checa primaria y secundaria)
	var _def_afi2 = variable_struct_exists(_defensor, "afinidad_secundaria") ? _defensor.afinidad_secundaria : "none";
	if (_defensor.pasiva_activa && (_defensor.afinidad == "Tierra" || _def_afi2 == "Tierra")) {
	    dano_final = max(1, round(dano_final * 0.80));
	}

    return dano_final;
}