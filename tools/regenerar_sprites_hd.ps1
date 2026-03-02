# ═══════════════════════════════════════════════════════════════
#  regenerar_sprites_hd.ps1
#  Regenera TODOS los sprites placeholder a resolución HD
#  para arte 2D estilizado de alta calidad.
#
#  Tamaños objetivo (4x del original):
#    Cuerpo jugador/enemigo .. 512×512   (era 128)
#    Cuerpo élite ........... 576×576   (era 144)
#    Cuerpo jefe ............ 768×768   (era 192)
#    Retratos ............... 256×256   (era 128)
#    Iconos estado/obj/runa . 128×128   (era 32)
#    Iconos habilidad/súper . 192×192   (era 48)
#    Barras ................. 512×48    (era 256×24)
#    Fondos ................. 1920×1080 (era 1280×720)
#    FX ..................... 256×256   (era 64)
#    UI varios .............. 2-4×
#
#  El código GML ya es resolution-independent: usa
#  sprite_get_width / sprite_get_height para calcular
#  la escala en tiempo de ejecución. Se puede importar
#  arte a CUALQUIER resolución sin tocar código.
# ═══════════════════════════════════════════════════════════════

Add-Type -AssemblyName System.Drawing

$spritesRoot = Join-Path $PSScriptRoot "..\sprites"

# ── Función: tamaño HD según nombre del sprite ──
function Get-HDSize($name) {
    # RETRATOS (antes que cuerpos para prioridad)
    if ($name -eq "spr_jugador_rostro")           { return @{w=256; h=256; ox=0;   oy=0;   origin=0} }
    if ($name -eq "spr_enemigo_rostro")            { return @{w=256; h=256; ox=0;   oy=0;   origin=0} }
    if ($name -match "^spr_rostro_")               { return @{w=256; h=256; ox=0;   oy=0;   origin=0} }

    # JEFES (antes que enemigos genéricos)
    if ($name -match "^spr_jefe_")                 { return @{w=768; h=768; ox=384; oy=384; origin=4} }

    # ÉLITES (antes que enemigos genéricos)
    if ($name -match "^spr_elite_")                { return @{w=576; h=576; ox=288; oy=288; origin=4} }

    # JUGADORES cuerpo
    if ($name -match "^spr_jugador")               { return @{w=512; h=512; ox=256; oy=256; origin=4} }

    # ENEMIGOS cuerpo (spr_enemigo y spr_enemigo_*)
    if ($name -match "^spr_enemigo")               { return @{w=512; h=512; ox=256; oy=256; origin=4} }

    # FONDOS
    if ($name -match "^spr_bg_")                   { return @{w=1920; h=1080; ox=0; oy=0; origin=0} }

    # ICONOS habilidad / súper (antes que genéricos)
    if ($name -match "^spr_ico_hab_")              { return @{w=192; h=192; ox=0; oy=0; origin=0} }
    if ($name -eq "spr_ico_super")                 { return @{w=192; h=192; ox=0; oy=0; origin=0} }

    # ICONOS genéricos (estado, objeto, runa, afinidad)
    if ($name -match "^spr_ico_")                  { return @{w=128; h=128; ox=0; oy=0; origin=0} }

    # BARRAS
    if ($name -match "^spr_barra_")                { return @{w=512; h=48;  ox=0; oy=0; origin=0} }

    # UI ELEMENTOS
    if ($name -eq "spr_marco_retrato")             { return @{w=280; h=280; ox=0;   oy=0;   origin=0} }
    if ($name -eq "spr_logo_arcadium")             { return @{w=1024;h=512; ox=512; oy=256; origin=4} }
    if ($name -eq "spr_boton_menu")                { return @{w=384; h=96;  ox=0;   oy=0;   origin=0} }
    if ($name -match "^spr_slot_")                 { return @{w=192; h=128; ox=0;   oy=0;   origin=0} }
    if ($name -eq "spr_cursor_select")             { return @{w=64;  h=64;  ox=0;   oy=0;   origin=0} }
    if ($name -eq "spr_panel_info")                { return @{w=640; h=480; ox=0;   oy=0;   origin=0} }

    # FX
    if ($name -match "^spr_fx_")                   { return @{w=256; h=256; ox=128; oy=128; origin=4} }

    # Fallback
    return @{w=512; h=512; ox=0; oy=0; origin=0}
}

# ── Función: color de placeholder según categoría ──
function Get-Color($name) {
    if ($name -match "^spr_rostro_elite")  { return [System.Drawing.Color]::FromArgb(160, 50, 50) }
    if ($name -match "^spr_rostro_")       { return [System.Drawing.Color]::FromArgb(120, 140, 160) }
    if ($name -match "_rostro$")           { return [System.Drawing.Color]::FromArgb(130, 130, 150) }
    if ($name -match "^spr_jefe_")         { return [System.Drawing.Color]::FromArgb(100, 30, 140) }
    if ($name -match "^spr_elite_")        { return [System.Drawing.Color]::FromArgb(170, 40, 40) }
    if ($name -match "^spr_jugador")       { return [System.Drawing.Color]::FromArgb(50, 100, 180) }
    if ($name -match "^spr_enemigo")       { return [System.Drawing.Color]::FromArgb(180, 50, 50) }
    if ($name -match "^spr_bg_")           { return [System.Drawing.Color]::FromArgb(25, 25, 45) }
    if ($name -match "^spr_ico_hab_")      { return [System.Drawing.Color]::FromArgb(40, 130, 140) }
    if ($name -match "^spr_ico_afinidad")  { return [System.Drawing.Color]::FromArgb(80, 140, 60) }
    if ($name -match "^spr_ico_runa")      { return [System.Drawing.Color]::FromArgb(140, 80, 160) }
    if ($name -match "^spr_ico_")          { return [System.Drawing.Color]::FromArgb(50, 140, 70) }
    if ($name -match "^spr_barra_")        { return [System.Drawing.Color]::FromArgb(80, 80, 100) }
    if ($name -match "^spr_fx_")           { return [System.Drawing.Color]::FromArgb(200, 140, 30) }
    if ($name -match "^spr_slot_")         { return [System.Drawing.Color]::FromArgb(70, 70, 90) }
    if ($name -eq "spr_logo_arcadium")     { return [System.Drawing.Color]::FromArgb(180, 150, 40) }
    if ($name -eq "spr_boton_menu")        { return [System.Drawing.Color]::FromArgb(60, 60, 80) }
    if ($name -eq "spr_cursor_select")     { return [System.Drawing.Color]::FromArgb(200, 180, 40) }
    if ($name -eq "spr_panel_info")        { return [System.Drawing.Color]::FromArgb(40, 40, 60) }
    if ($name -eq "spr_marco_retrato")     { return [System.Drawing.Color]::FromArgb(160, 130, 50) }
    return [System.Drawing.Color]::FromArgb(90, 90, 90)
}

# ── Sprites a omitir ──
$skip = @("spr_contador")

$count = 0
$errors = 0

Get-ChildItem $spritesRoot -Directory | ForEach-Object {
    $sprName = $_.Name
    $sprDir  = $_.FullName
    $yyFile  = Join-Path $sprDir "$sprName.yy"

    if (!(Test-Path $yyFile))       { return }
    if ($sprName -in $skip)         { return }

    $size  = Get-HDSize $sprName
    $color = Get-Color  $sprName

    try {
        # ── Leer .yy para obtener GUIDs ──
        # GameMaker usa JSON con trailing commas → limpiar antes de parsear
        $yyRaw  = Get-Content $yyFile -Raw -Encoding UTF8
        $yyClean = $yyRaw -replace ',(\s*[}\]])', '$1'
        $yyJson = $yyClean | ConvertFrom-Json

        $frameGuid = $yyJson.frames[0].name
        $layerGuid = $yyJson.layers[0].name

        $framePng = Join-Path $sprDir "$frameGuid.png"
        $layerDir = Join-Path $sprDir "layers\$frameGuid"
        $layerPng = Join-Path $layerDir "$layerGuid.png"

        # ── Crear bitmap HD ──
        $bmp = New-Object System.Drawing.Bitmap($size.w, $size.h)
        $g   = [System.Drawing.Graphics]::FromImage($bmp)
        $g.SmoothingMode     = 'AntiAlias'
        $g.TextRenderingHint = 'AntiAliasGridFit'
        $g.Clear($color)

        # Etiqueta de texto
        $fontSize = [math]::Max(10, [math]::Min(32, [int]($size.w / 14)))
        $font  = New-Object System.Drawing.Font("Segoe UI", $fontSize, [System.Drawing.FontStyle]::Bold)
        $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(220, 255, 255, 255))
        $sf    = New-Object System.Drawing.StringFormat
        $sf.Alignment     = 'Center'
        $sf.LineAlignment = 'Center'
        $rect  = New-Object System.Drawing.RectangleF(4, 4, ($size.w - 8), ($size.h - 8))
        $g.DrawString($sprName, $font, $brush, $rect, $sf)

        # Subtexto con resolución
        $subSize = [math]::Max(8, [int]($fontSize * 0.5))
        $fontSub = New-Object System.Drawing.Font("Segoe UI", $subSize)
        $brushSub= New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(160, 255, 255, 255))
        $sfSub   = New-Object System.Drawing.StringFormat
        $sfSub.Alignment     = 'Center'
        $sfSub.LineAlignment = 'Far'
        $rectSub = New-Object System.Drawing.RectangleF(4, 4, ($size.w - 8), ($size.h - 12))
        $g.DrawString("$($size.w)x$($size.h)", $fontSub, $brushSub, $rectSub, $sfSub)

        # Borde
        $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(180, 255, 255, 255), 2)
        $g.DrawRectangle($pen, 1, 1, ($size.w - 3), ($size.h - 3))

        # Cruz central para sprites con origin=center
        if ($size.origin -eq 4) {
            $penCross = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(100, 255, 255, 255), 1)
            $g.DrawLine($penCross, ($size.w / 2), 0, ($size.w / 2), $size.h)
            $g.DrawLine($penCross, 0, ($size.h / 2), $size.w, ($size.h / 2))
            $penCross.Dispose()
        }

        $g.Dispose()

        # ── Guardar PNGs ──
        $bmp.Save($framePng, [System.Drawing.Imaging.ImageFormat]::Png)
        if (!(Test-Path $layerDir)) { New-Item $layerDir -ItemType Directory -Force | Out-Null }
        $bmp.Save($layerPng, [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()

        $font.Dispose(); $fontSub.Dispose()
        $brush.Dispose(); $brushSub.Dispose()
        $pen.Dispose(); $sf.Dispose(); $sfSub.Dispose()

        # ── Actualizar .yy (dimensiones, origin, bbox) ──
        $yyText = $yyRaw
        $yyText = $yyText -replace '"width":\s*\d+',      ('"width":' + $size.w)
        $yyText = $yyText -replace '"height":\s*\d+',     ('"height":' + $size.h)
        $yyText = $yyText -replace '"xorigin":\s*\d+',    ('"xorigin":' + $size.ox)
        $yyText = $yyText -replace '"yorigin":\s*\d+',    ('"yorigin":' + $size.oy)
        $yyText = $yyText -replace '"origin":\s*\d+',     ('"origin":' + $size.origin)
        $yyText = $yyText -replace '"bbox_bottom":\s*\d+',('"bbox_bottom":' + ($size.h - 1))
        $yyText = $yyText -replace '"bbox_left":\s*\d+',  '"bbox_left":0'
        $yyText = $yyText -replace '"bbox_right":\s*\d+', ('"bbox_right":' + ($size.w - 1))
        $yyText = $yyText -replace '"bbox_top":\s*\d+',   '"bbox_top":0'

        [System.IO.File]::WriteAllText($yyFile, $yyText, [System.Text.Encoding]::UTF8)

        $count++
        Write-Host "  HD [$($size.w.ToString().PadLeft(4))x$($size.h.ToString().PadLeft(4))] $sprName" -ForegroundColor Green
    }
    catch {
        $errors++
        Write-Host "  ERROR $sprName : $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  $count sprites regenerados a resolucion HD" -ForegroundColor Cyan
if ($errors -gt 0) { Write-Host "  $errors errores" -ForegroundColor Red }
Write-Host "  El codigo GML escala automaticamente." -ForegroundColor Cyan
Write-Host "  Reemplaza los placeholder con arte real" -ForegroundColor Cyan
Write-Host "  a la resolucion que desees." -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
