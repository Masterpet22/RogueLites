/// scr_calcular_dano(atacante, defensor)
function scr_calcular_dano(_atacante, _defensor) {

    var base_ataque = _atacante.ataque_base;

	var defensa_obj = _defensor.defensa_base;
	if (variable_struct_exists(_defensor, "defensa_bonus_temp")) {
	    defensa_obj += _defensor.defensa_bonus_temp;
	}

	var dano_bruto = base_ataque - (defensa_obj * FACTOR_DEF_GLOBAL);

    // Afinidad — usa versión dual para soportar jefes con 2 afinidades
    var mult_afi = scr_multiplicador_afinidad_dual(_atacante, _defensor);

    var dano_final = dano_bruto * mult_afi;

    // Aseguramos daño mínimo y número entero
    dano_final = max(1, round(dano_final));
	
	// Pasiva de FUEGO / ofensivas → lee bono de scr_datos_afinidades
	var _atk_afi2 = variable_struct_exists(_atacante, "afinidad_secundaria") ? _atacante.afinidad_secundaria : "none";
	if (_atacante.pasiva_activa) {
	    var _ofensivas_cd = ["Fuego", "Rayo", "Sombra", "Arcano"];
	    for (var _oi = 0; _oi < 4; _oi++) {
	        if (_atacante.afinidad == _ofensivas_cd[_oi] || _atk_afi2 == _ofensivas_cd[_oi]) {
	            var _bono_cd = scr_datos_afinidades(_ofensivas_cd[_oi]).bono;
	            dano_final = round(dano_final * _bono_cd);
	        }
	    }
	}

	// Pasiva de TIERRA influye en defensa (checa primaria y secundaria)
	var _def_afi2 = variable_struct_exists(_defensor, "afinidad_secundaria") ? _defensor.afinidad_secundaria : "none";
	if (_defensor.pasiva_activa && (_defensor.afinidad == "Tierra" || _def_afi2 == "Tierra")) {
	    var _bono_tierra_cd = scr_datos_afinidades("Tierra").bono;
	    dano_final = max(1, round(dano_final * (2.0 - _bono_tierra_cd)));
	}

    return dano_final;
}