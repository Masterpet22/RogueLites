/// @file scr_sonido_habilidad.gml
/// @description  Reproduce el efecto de sonido asociado a una habilidad.
///   Cada habilidad se categoriza por elemento/tipo y se le asigna un sonido.
///   Si no tiene sonido específico, usa snd_default como fallback.
///
///   Mapeo de sonidos:
///     snd_1  — Fuego / Físico / Impacto pesado
///     snd_2  — Agua / Hielo / Luz / Curación
///     snd_3  — Planta / Tierra / Defensivo
///     snd_4  — Rayo / Oscuridad / Arcano / Especial

/// @function scr_sonido_habilidad(id_habilidad)
/// @description  Reproduce el sonido correcto para la habilidad dada.
/// @param {string} _id  ID de la habilidad
function scr_sonido_habilidad(_id) {
    var _snd = scr_sonido_obtener(_id);
    audio_play_sound(_snd, 1, false);
}

/// @function scr_sonido_obtener(id_habilidad)
/// @description  Devuelve el asset de sonido para una habilidad.
/// @param {string} _id
/// @returns {Asset.GMSound}
function scr_sonido_obtener(_id) {

    // ── Fuego / Físico / Impacto → snd_1 ──
    if (string_pos("fuego", _id)
     || string_pos("llama", _id)
     || string_pos("carmesi", _id)
     || string_pos("titan", _id)
     || string_pos("ignea", _id)
     || string_pos("igneo", _id)
     || string_pos("incandescente", _id)
     || string_pos("magma", _id)
     || string_pos("erupcion", _id)
     || string_pos("pira", _id)
     || string_pos("inmolacion", _id)
     || string_pos("ceniza", _id)
     || string_pos("pilar_llama", _id)
     || _id == "ataque_basico"
     || _id == "golpe_guardia"
     || _id == "corte_rapido"
     || _id == "impacto_tectonico"
     || _id == "estocada_critica"
     || _id == "golpe_primordial"
     || _id == "mordida_vacia"
     || _id == "sincronia_magma") {
        return snd_1;
    }

    // ── Agua / Hielo / Luz / Curación → snd_2 ──
    if (string_pos("glaciar", _id)
     || string_pos("marina", _id)
     || string_pos("abisal", _id)
     || string_pos("tsunami", _id)
     || string_pos("diluvio", _id)
     || string_pos("oleaje", _id)
     || string_pos("rocio", _id)
     || string_pos("ventisca", _id)
     || string_pos("maremoto", _id)
     || string_pos("torrente", _id)
     || string_pos("prision_glaciar", _id)
     || string_pos("radiante", _id)
     || string_pos("bendicion", _id)
     || string_pos("amanecer", _id)
     || string_pos("celestial", _id)
     || string_pos("sagrado", _id)
     || string_pos("purificador", _id)
     || string_pos("divina", _id)
     || string_pos("fulgor_celestial", _id)
     || string_pos("relampago_sagrado", _id)
     || string_pos("plegaria", _id)
     || _id == "baluarte_ferreo"
     || _id == "hoja_radiante"
     || _id == "embestida_solar"
     || _id == "juicio_celestial"
     || _id == "destello_debil"
     || _id == "golpe_sagrado"
     || _id == "juicio_sagrado"
     || _id == "sincronia_fulgor") {
        return snd_2;
    }

    // ── Planta / Tierra / Defensivo → snd_3 ──
    if (string_pos("espina", _id)
     || string_pos("enredadera", _id)
     || string_pos("drenaje", _id)
     || string_pos("espora", _id)
     || string_pos("selva", _id)
     || string_pos("semilla", _id)
     || string_pos("vegetal", _id)
     || string_pos("regenerativ", _id)
     || string_pos("pantano", _id)
     || string_pos("fotovoltaica", _id)
     || string_pos("sismico", _id)
     || string_pos("avalancha", _id)
     || string_pos("petreo", _id)
     || string_pos("cataclismo", _id)
     || string_pos("continental", _id)
     || string_pos("lanzar_rocas", _id)
     || string_pos("temblor", _id)
     || string_pos("terremoto", _id)
     || string_pos("muro_piedra", _id)
     || string_pos("fortaleza_petrea", _id)
     || string_pos("rafaga_cortante", _id)
     || _id == "escudo_petreo"
     || _id == "muro_magmatico"
     || _id == "descarga_esencia"
     || _id == "cortina_cenizas"
     || _id == "barrera_fotovoltaica"
     || _id == "genesis_esporal"
     || _id == "sincronia_brote") {
        return snd_3;
    }

    // ── Rayo / Oscuridad / Arcano / Especial → snd_4 ──
    if (string_pos("descarga", _id)
     || string_pos("electri", _id)
     || string_pos("tormenta", _id)
     || string_pos("rayo", _id)
     || string_pos("relampago", _id)
     || string_pos("voltaico", _id)
     || string_pos("chispazo", _id)
     || string_pos("arco_voltaico", _id)
     || string_pos("aullido", _id)
     || string_pos("umbral", _id)
     || string_pos("oscura", _id)
     || string_pos("alma", _id)
     || string_pos("noche", _id)
     || string_pos("eclipse", _id)
     || string_pos("sombra", _id)
     || string_pos("vacio", _id)
     || string_pos("nocturno", _id)
     || string_pos("runico", _id)
     || string_pos("arcano", _id)
     || string_pos("arcana", _id)
     || string_pos("singularidad", _id)
     || string_pos("ruptura", _id)
     || string_pos("dimensional", _id)
     || string_pos("cometa", _id)
     || string_pos("sello", _id)
     || string_pos("silencio", _id)
     || string_pos("agujero", _id)
     || string_pos("abismal", _id)
     || string_pos("sifon", _id)
     || string_pos("apocalipsis", _id)
     || string_pos("espejo_voraz", _id)
     || string_pos("consumo_absoluto", _id)
     || string_pos("genesis_final", _id)
     || string_pos("resonancia", _id)
     || string_pos("armonia", _id)
     || string_pos("devorador", _id)
     || string_pos("debilitante", _id)
     || string_pos("distorsion", _id)
     || _id == "lanza_oscura"
     || _id == "sincronia_vacio") {
        return snd_4;
    }

    // ── Fallback → snd_default ──
    return snd_default;
}

/// @function scr_sonido_super()
/// @description  Reproduce sonido especial para ataques súper.
///               Usa snd_4 (el más épico/especial).
function scr_sonido_super() {
    audio_play_sound(snd_4, 2, false);
}
