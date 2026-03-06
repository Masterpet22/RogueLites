/// @file scr_energia_combate.gml
/// @description  Sistema de Energía (recurso de corto plazo).
///   Barra de 100 unidades. Regeneración pasiva lenta.
///   Cada habilidad tiene un costo fijo. Si energía < costo → bloqueada.
///   Si energía llega a 0 → agotamiento (sin regen por 1.5s).
///   Al gastar energía se acumula esencia (cada 10 energía → +1% esencia).


// ══════════════════════════════════════════════════════════════
//  scr_energia_costo_habilidad(id_habilidad)
//  Retorna el costo de energía de la habilidad indicada.
// ══════════════════════════════════════════════════════════════
function scr_energia_costo_habilidad(_id) {

    switch (_id) {

        // ─── HABILIDADES DE CLASE ───
        case "golpe_guardia":           return 10;  // Vanguardia
        case "corte_rapido":            return 8;   // Filotormenta
        case "impacto_tectonico":       return 18;  // Quebrador
        case "baluarte_ferreo":         return 15;  // Centinela
        case "estocada_critica":        return 12;  // Duelista
        case "descarga_esencia":        return 20;  // Canalizador

        // ─── ARMA BASE ───
        case "ataque_basico":           return 5;

        // ─── FUEGO ───
        case "ataque_fuego_basico":     return 8;
        case "ataque_fuego_mejorado":   return 12;
        case "explosion_carmesi":       return 20;
        case "llamarada_solar":         return 15;
        case "furia_del_titan":         return 30;

        // ─── AGUA ───
        case "corte_glaciar":           return 8;
        case "lanza_marina":            return 12;
        case "corriente_abisal":        return 18;
        case "tsunami":                 return 15;
        case "diluvio_eterno":          return 28;

        // ─── PLANTA ───
        case "latigazo_espina":         return 8;
        case "enredadera_voraz":        return 12;
        case "drenaje_vital":           return 16;
        case "explosion_espora":        return 15;
        case "selva_eterna":            return 28;

        // ─── RAYO ───
        case "descarga_rapida":         return 6;
        case "cadena_electrica":        return 10;
        case "tormenta_fugaz":          return 18;
        case "rayo_fulminante":         return 14;
        case "juicio_relampago":        return 30;

        // ─── TIERRA ───
        case "golpe_sismico":           return 10;
        case "avalancha":               return 14;
        case "escudo_petreo":           return 18;
        case "cataclismo":              return 22;
        case "furia_continental":       return 30;

        // ─── SOMBRA ───
        case "tajo_umbral":             return 8;
        case "siega_oscura":            return 12;
        case "drenar_alma":             return 20;
        case "noche_eterna":            return 16;
        case "eclipse_total":           return 30;

        // ─── LUZ ───
        case "hoja_radiante":           return 8;
        case "embestida_solar":         return 12;
        case "bendicion_luz":           return 18;
        case "amanecer_divino":         return 16;
        case "juicio_celestial":        return 28;

        // ─── ARCANO ───
        case "pulso_runico":            return 8;
        case "corte_arcano":            return 10;
        case "onda_arcana":             return 18;
        case "singularidad_arcana":     return 16;
        case "ruptura_dimensional":     return 30;
    }

    // Fallback: costo medio para habilidades no registradas
    return 10;
}


// ══════════════════════════════════════════════════════════════
//  scr_energia_puede_gastar(personaje, costo)
//  Retorna true si el personaje tiene energía suficiente.
// ══════════════════════════════════════════════════════════════
function scr_energia_puede_gastar(_p, _costo) {
    return (_p.energia >= _costo);
}


// ══════════════════════════════════════════════════════════════
//  scr_energia_gastar(personaje, costo)
//  Consume energía. Si llega a 0, activa penalización de agotamiento.
//  Acumula gasto para generación de esencia.
// ══════════════════════════════════════════════════════════════
function scr_energia_gastar(_p, _costo) {
    _p.energia = max(0, _p.energia - _costo);
    _p.energia_gastada_acum += _costo;

    // ── Generar esencia por gasto de energía ──
    // Cada ENERGIA_ESENCIA_RATIO unidades gastadas → +1% de esencia
    while (_p.energia_gastada_acum >= ENERGIA_ESENCIA_RATIO) {
        _p.energia_gastada_acum -= ENERGIA_ESENCIA_RATIO;
        _p.esencia = clamp(_p.esencia + 1, 0, _p.esencia_llena);
    }

    // ── Agotamiento: si llega a 0, penalización ──
    if (_p.energia <= 0) {
        _p.energia_agotamiento_timer = round(GAME_FPS * ENERGIA_AGOTAMIENTO_SEG);
        show_debug_message("⚡ " + _p.nombre + " — ¡AGOTAMIENTO de energía! Regen detenida " + string(ENERGIA_AGOTAMIENTO_SEG) + "s");
    }
}


// ══════════════════════════════════════════════════════════════
//  scr_energia_actualizar(personaje)
//  Llamar cada frame. Regeneración pasiva + agotamiento.
// ══════════════════════════════════════════════════════════════
function scr_energia_actualizar(_p) {
    // Decrementar agotamiento
    if (_p.energia_agotamiento_timer > 0) {
        _p.energia_agotamiento_timer -= 1;
        return; // Sin regeneración durante agotamiento
    }

    // Regeneración pasiva: ENERGIA_REGEN_PCT por segundo
    var _regen_por_frame = (_p.energia_max * ENERGIA_REGEN_PCT) / GAME_FPS;
    _p.energia = min(_p.energia_max, _p.energia + _regen_por_frame);
}
