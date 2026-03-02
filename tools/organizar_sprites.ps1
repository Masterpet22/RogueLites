# organizar_sprites.ps1
# Actualiza el parent de cada sprite .yy para organizar en subcarpetas del Asset Browser

$base = "c:\Users\epren\GameMakerProjects\RogueLites\sprites"

# Mapa: carpeta destino => lista de prefijos/nombres exactos
$categorias = @{
    "personajes" = @(
        "spr_jugador$", "spr_jugador_rostro$",
        "spr_jugador_kael", "spr_jugador_lys", "spr_jugador_torvan", "spr_jugador_maelis",
        "spr_jugador_saren", "spr_jugador_nerya", "spr_jugador_thalys", "spr_jugador_brenn",
        "spr_rostro_kael", "spr_rostro_lys", "spr_rostro_torvan", "spr_rostro_maelis",
        "spr_rostro_saren", "spr_rostro_nerya", "spr_rostro_thalys", "spr_rostro_brenn"
    )
    "enemigos" = @(
        "spr_enemigo$", "spr_enemigo_rostro$",
        "spr_enemigo_soldado_igneo", "spr_enemigo_vigia_boreal", "spr_enemigo_halito_verde",
        "spr_enemigo_bestia_tronadora", "spr_enemigo_guardian_terracota", "spr_enemigo_naufrago",
        "spr_enemigo_paladin_marchito", "spr_enemigo_errante_runico",
        "spr_rostro_soldado_igneo", "spr_rostro_vigia_boreal", "spr_rostro_halito_verde",
        "spr_rostro_bestia_tronadora", "spr_rostro_guardian_terracota", "spr_rostro_naufrago",
        "spr_rostro_paladin_marchito", "spr_rostro_errante_runico"
    )
    "elites" = @(
        "spr_elite_soldado_igneo", "spr_elite_vigia_boreal", "spr_elite_halito_verde",
        "spr_elite_bestia_tronadora", "spr_elite_guardian_terracota", "spr_elite_naufrago",
        "spr_elite_paladin_marchito", "spr_elite_errante_runico",
        "spr_rostro_elite_soldado_igneo", "spr_rostro_elite_vigia_boreal", "spr_rostro_elite_halito_verde",
        "spr_rostro_elite_bestia_tronadora", "spr_rostro_elite_guardian_terracota", "spr_rostro_elite_naufrago",
        "spr_rostro_elite_paladin_marchito", "spr_rostro_elite_errante_runico"
    )
    "jefes" = @(
        "spr_jefe_titan_forjas", "spr_jefe_coloso_fango", "spr_jefe_sentinela_cielo",
        "spr_jefe_oraculo_abismo", "spr_jefe_devorador", "spr_jefe_primer_conductor",
        "spr_rostro_titan_forjas", "spr_rostro_coloso_fango", "spr_rostro_sentinela_cielo",
        "spr_rostro_oraculo_abismo", "spr_rostro_devorador", "spr_rostro_primer_conductor"
    )
    "fondos" = @(
        "spr_bg_menu", "spr_bg_combate", "spr_bg_select", "spr_bg_enemy_select",
        "spr_bg_forja", "spr_bg_tienda", "spr_bg_torre"
    )
    "iconos" = @(
        "spr_ico_quemadura", "spr_ico_veneno", "spr_ico_regeneracion", "spr_ico_muro_tierra",
        "spr_ico_aceleracion", "spr_ico_ralentizacion", "spr_ico_vulnerabilidad", "spr_ico_supresion",
        "spr_ico_pocion_basica", "spr_ico_pocion_media", "spr_ico_elixir_esencia",
        "spr_ico_tonico_ataque", "spr_ico_tonico_defensa",
        "spr_ico_runa_furia", "spr_ico_runa_fortaleza", "spr_ico_runa_celeridad",
        "spr_ico_runa_ultimo_aliento", "spr_ico_runa_vampirica", "spr_ico_runa_cristal",
        "spr_ico_hab_clase", "spr_ico_hab_arma_1", "spr_ico_hab_arma_2",
        "spr_ico_hab_arma_3", "spr_ico_super",
        "spr_ico_afinidad_fuego", "spr_ico_afinidad_agua", "spr_ico_afinidad_planta",
        "spr_ico_afinidad_rayo", "spr_ico_afinidad_tierra", "spr_ico_afinidad_sombra",
        "spr_ico_afinidad_luz", "spr_ico_afinidad_arcano"
    )
    "ui" = @(
        "spr_barra_vida", "spr_barra_vida_bg", "spr_barra_esencia", "spr_barra_esencia_bg",
        "spr_barra_cooldown", "spr_marco_retrato", "spr_logo_arcadium", "spr_boton_menu",
        "spr_slot_objeto", "spr_slot_runa", "spr_cursor_select", "spr_panel_info"
    )
    "fx" = @(
        "spr_fx_impacto", "spr_fx_critico", "spr_fx_curacion",
        "spr_fx_esquiva", "spr_fx_esencia", "spr_fx_super"
    )
}

$countUpdated = 0

foreach ($cat in $categorias.Keys) {
    $parentName = $cat
    $parentPath = "folders/sprites/$cat.yy"

    foreach ($sprName in $categorias[$cat]) {
        # Quitar el $ de regex para el path real
        $dirName = $sprName -replace '\$', ''
        $yyPath = Join-Path $base "$dirName\$dirName.yy"

        if (Test-Path $yyPath) {
            $content = Get-Content $yyPath -Raw -Encoding UTF8
            # Reemplazar el parent
            $newParent = @"
  "parent": {
    "name": "$parentName",
    "path": "$parentPath"
  },
"@
            $content = $content -replace '"parent"\s*:\s*\{[^}]+\}\s*,', $newParent
            Set-Content $yyPath -Value $content -Encoding UTF8 -NoNewline
            $countUpdated++
            Write-Host "  OK: $dirName -> $cat"
        } else {
            Write-Host "  SKIP: $yyPath no existe"
        }
    }
}

Write-Host "`n=== $countUpdated sprites organizados en subcarpetas ==="
