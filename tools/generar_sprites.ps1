# ============================================================
# ARCADIUM — Generador de Sprites Placeholder
# Genera todas las carpetas, archivos .yy y PNGs placeholder
# para todos los sprites necesarios del juego.
# ============================================================

$ProjectRoot = "c:\Users\epren\GameMakerProjects\RogueLites"
$SpritesDir  = "$ProjectRoot\sprites"

# Colores por afinidad (R,G,B)
$ColorAfinidad = @{
    "Fuego"   = @(200, 50, 30)
    "Agua"    = @(30, 80, 200)
    "Planta"  = @(34, 139, 34)
    "Rayo"    = @(200, 200, 40)
    "Tierra"  = @(139, 90, 43)
    "Sombra"  = @(80, 20, 120)
    "Luz"     = @(240, 210, 80)
    "Arcano"  = @(128, 0, 200)
    "Neutro"  = @(100, 100, 100)
    "UI"      = @(60, 60, 80)
}

# ============================================================
# Función para crear un PNG placeholder con color y texto
# ============================================================
function New-PlaceholderPNG {
    param(
        [string]$Path,
        [int]$Width,
        [int]$Height,
        [int[]]$Color,
        [string]$Label
    )

    Add-Type -AssemblyName System.Drawing

    $bmp = New-Object System.Drawing.Bitmap($Width, $Height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)

    # Fondo del color de afinidad
    $bgBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, $Color[0], $Color[1], $Color[2]))
    $g.FillRectangle($bgBrush, 0, 0, $Width, $Height)

    # Borde
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::White, 2)
    $g.DrawRectangle($borderPen, 1, 1, $Width - 3, $Height - 3)

    # Cruz diagonal para que se note que es placeholder
    $crossPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(80, 255, 255, 255), 1)
    $g.DrawLine($crossPen, 0, 0, $Width, $Height)
    $g.DrawLine($crossPen, $Width, 0, 0, $Height)

    # Texto del label
    if ($Label) {
        $fontSize = [Math]::Max(6, [Math]::Min(14, [int]($Width / 10)))
        $font = New-Object System.Drawing.Font("Arial", $fontSize, [System.Drawing.FontStyle]::Bold)
        $textBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $sf = New-Object System.Drawing.StringFormat
        $sf.Alignment = [System.Drawing.StringAlignment]::Center
        $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
        $rect = New-Object System.Drawing.RectangleF(2, 2, ($Width - 4), ($Height - 4))
        $g.DrawString($Label, $font, $textBrush, $rect, $sf)
        $font.Dispose()
        $textBrush.Dispose()
        $sf.Dispose()
    }

    $g.Dispose()
    $bgBrush.Dispose()
    $borderPen.Dispose()
    $crossPen.Dispose()

    $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose()
}

# ============================================================
# Función para crear la estructura completa de un sprite GMS2
# ============================================================
function New-GMSprite {
    param(
        [string]$Name,
        [int]$Width,
        [int]$Height,
        [int]$OriginX,
        [int]$OriginY,
        [int]$Origin,       # 0=TopLeft, 4=MiddleCenter, 9=Custom
        [int[]]$Color,
        [string]$Label,
        [string]$Parent = "sprites",
        [string]$ParentPath = "folders/sprites.yy"
    )

    $sprDir = "$SpritesDir\$Name"
    $layerDir = "$sprDir\layers"

    # Generar GUIDs
    $frameGuid = [Guid]::NewGuid().ToString()
    $layerGuid = [Guid]::NewGuid().ToString()

    # Crear carpetas
    New-Item -ItemType Directory -Path $sprDir -Force | Out-Null
    New-Item -ItemType Directory -Path "$layerDir\$frameGuid" -Force | Out-Null

    # Crear PNG principal (en la raíz de la carpeta del sprite)
    New-PlaceholderPNG -Path "$sprDir\$frameGuid.png" -Width $Width -Height $Height -Color $Color -Label $Label

    # Crear PNG de la capa (en layers/GUID/)
    New-PlaceholderPNG -Path "$layerDir\$frameGuid\$layerGuid.png" -Width $Width -Height $Height -Color $Color -Label $Label

    # Crear archivo .yy
    $yyContent = @"
{
  "`$GMSprite":"v2",
  "%Name":"$Name",
  "bboxMode":0,
  "bbox_bottom":$($Height - 1),
  "bbox_left":0,
  "bbox_right":$($Width - 1),
  "bbox_top":0,
  "collisionKind":1,
  "collisionTolerance":0,
  "DynamicTexturePage":false,
  "edgeFiltering":false,
  "For3D":false,
  "frames":[
    {"`$GMSpriteFrame":"v1","%Name":"$frameGuid","name":"$frameGuid","resourceType":"GMSpriteFrame","resourceVersion":"2.0",},
  ],
  "gridX":0,
  "gridY":0,
  "height":$Height,
  "HTile":false,
  "layers":[
    {"`$GMImageLayer":"","%Name":"$layerGuid","blendMode":0,"displayName":"default","isLocked":false,"name":"$layerGuid","opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":true,},
  ],
  "name":"$Name",
  "nineSlice":null,
  "origin":$Origin,
  "parent":{
    "name":"$Parent",
    "path":"$ParentPath",
  },
  "preMultiplyAlpha":false,
  "resourceType":"GMSprite",
  "resourceVersion":"2.0",
  "sequence":{
    "`$GMSequence":"v1",
    "%Name":"$Name",
    "autoRecord":true,
    "backdropHeight":768,
    "backdropImageOpacity":0.5,
    "backdropImagePath":"",
    "backdropWidth":1366,
    "backdropXOffset":0.0,
    "backdropYOffset":0.0,
    "events":{
      "`$KeyframeStore<MessageEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MessageEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "eventStubScript":null,
    "eventToFunction":{},
    "length":1.0,
    "lockOrigin":false,
    "moments":{
      "`$KeyframeStore<MomentsEventKeyframe>":"",
      "Keyframes":[],
      "resourceType":"KeyframeStore<MomentsEventKeyframe>",
      "resourceVersion":"2.0",
    },
    "name":"$Name",
    "playback":1,
    "playbackSpeed":30.0,
    "playbackSpeedType":0,
    "resourceType":"GMSequence",
    "resourceVersion":"2.0",
    "showBackdrop":true,
    "showBackdropImage":false,
    "timeUnits":1,
    "tracks":[
      {"`$GMSpriteFramesTrack":"","builtinName":0,"events":[],"inheritsTrackColour":true,"interpolation":1,"isCreationTrack":false,"keyframes":{"`$KeyframeStore<SpriteFrameKeyframe>":"","Keyframes":[
            {"`$Keyframe<SpriteFrameKeyframe>":"","Channels":{
                "0":{"`$SpriteFrameKeyframe":"","Id":{"name":"$frameGuid","path":"sprites/$Name/$Name.yy",},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",},
              },"Disabled":false,"id":"$([Guid]::NewGuid().ToString())","IsCreationKey":false,"Key":0.0,"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":false,},
          ],"resourceType":"KeyframeStore<SpriteFrameKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"frames","resourceType":"GMSpriteFramesTrack","resourceVersion":"2.0","spriteId":null,"trackColour":0,"tracks":[],"traits":0,},
    ],
    "visibleRange":null,
    "volume":1.0,
    "xorigin":$OriginX,
    "yorigin":$OriginY,
  },
  "swatchColours":null,
  "swfPrecision":0.5,
  "textureGroupId":{
    "name":"Default",
    "path":"texturegroups/Default",
  },
  "type":0,
  "VTile":false,
  "width":$Width,
}
"@
    Set-Content -Path "$sprDir\$Name.yy" -Value $yyContent -Encoding UTF8

    return @{ Name = $Name; Path = "sprites/$Name/$Name.yy" }
}

# ============================================================
# DEFINICIÓN DE TODOS LOS SPRITES
# ============================================================
$allSprites = @()

Write-Host "=== GENERANDO SPRITES PLACEHOLDER PARA ARCADIUM ===" -ForegroundColor Cyan

# ────────────────────────────────────────────────────────────
# 1. PERSONAJES JUGABLES — Cuerpo (128x128, origen centro)
# ────────────────────────────────────────────────────────────
Write-Host "`n[1/9] Personajes - Cuerpo completo..." -ForegroundColor Green
$jugadores = @(
    @{ Name = "spr_jugador_kael";    Color = $ColorAfinidad["Fuego"];  Label = "KAEL`nVanguardia" },
    @{ Name = "spr_jugador_lys";     Color = $ColorAfinidad["Rayo"];   Label = "LYS`nFilotormenta" },
    @{ Name = "spr_jugador_torvan";  Color = $ColorAfinidad["Tierra"]; Label = "TORVAN`nQuebrador" },
    @{ Name = "spr_jugador_maelis";  Color = $ColorAfinidad["Luz"];    Label = "MAELIS`nCentinela" },
    @{ Name = "spr_jugador_saren";   Color = $ColorAfinidad["Sombra"]; Label = "SAREN`nDuelista" },
    @{ Name = "spr_jugador_nerya";   Color = $ColorAfinidad["Arcano"]; Label = "NERYA`nCanalizador" },
    @{ Name = "spr_jugador_thalys";  Color = $ColorAfinidad["Agua"];   Label = "THALYS`nCentinela" },
    @{ Name = "spr_jugador_brenn";   Color = $ColorAfinidad["Planta"]; Label = "BRENN`nQuebrador" }
)
foreach ($j in $jugadores) {
    $r = New-GMSprite -Name $j.Name -Width 128 -Height 128 -OriginX 64 -OriginY 64 -Origin 4 -Color $j.Color -Label $j.Label
    $allSprites += $r
    Write-Host "  + $($j.Name)" -ForegroundColor DarkGreen
}

# ────────────────────────────────────────────────────────────
# 2. PERSONAJES JUGABLES — Retrato (128x128, origen top-left)
# ────────────────────────────────────────────────────────────
Write-Host "`n[2/9] Personajes - Retratos..." -ForegroundColor Green
$retratos = @(
    @{ Name = "spr_rostro_kael";    Color = $ColorAfinidad["Fuego"];  Label = "ROSTRO`nKAEL" },
    @{ Name = "spr_rostro_lys";     Color = $ColorAfinidad["Rayo"];   Label = "ROSTRO`nLYS" },
    @{ Name = "spr_rostro_torvan";  Color = $ColorAfinidad["Tierra"]; Label = "ROSTRO`nTORVAN" },
    @{ Name = "spr_rostro_maelis";  Color = $ColorAfinidad["Luz"];    Label = "ROSTRO`nMAELIS" },
    @{ Name = "spr_rostro_saren";   Color = $ColorAfinidad["Sombra"]; Label = "ROSTRO`nSAREN" },
    @{ Name = "spr_rostro_nerya";   Color = $ColorAfinidad["Arcano"]; Label = "ROSTRO`nNERYA" },
    @{ Name = "spr_rostro_thalys";  Color = $ColorAfinidad["Agua"];   Label = "ROSTRO`nTHALYS" },
    @{ Name = "spr_rostro_brenn";   Color = $ColorAfinidad["Planta"]; Label = "ROSTRO`nBRENN" }
)
foreach ($r in $retratos) {
    $res = New-GMSprite -Name $r.Name -Width 128 -Height 128 -OriginX 0 -OriginY 0 -Origin 0 -Color $r.Color -Label $r.Label
    $allSprites += $res
    Write-Host "  + $($r.Name)" -ForegroundColor DarkGreen
}

# ────────────────────────────────────────────────────────────
# 3. ENEMIGOS COMUNES — Cuerpo + Retrato (128x128)
# ────────────────────────────────────────────────────────────
Write-Host "`n[3/9] Enemigos comunes..." -ForegroundColor Green
$enemigos_comunes = @(
    @{ Id = "soldado_igneo";        Label = "Soldado`nIgneo";      Afi = "Fuego" },
    @{ Id = "vigia_boreal";         Label = "Vigia`nBoreal";       Afi = "Agua" },
    @{ Id = "halito_verde";         Label = "Halito`nVerde";       Afi = "Planta" },
    @{ Id = "bestia_tronadora";     Label = "Bestia`nTronadora";   Afi = "Rayo" },
    @{ Id = "guardian_terracota";   Label = "Guardian`nTerracota"; Afi = "Tierra" },
    @{ Id = "naufrago";             Label = "Naufrago`nOscuridad"; Afi = "Sombra" },
    @{ Id = "paladin_marchito";     Label = "Paladin`nMarchito";   Afi = "Luz" },
    @{ Id = "errante_runico";       Label = "Errante`nRunico";     Afi = "Arcano" }
)
foreach ($e in $enemigos_comunes) {
    # Cuerpo
    $r1 = New-GMSprite -Name "spr_enemigo_$($e.Id)" -Width 128 -Height 128 -OriginX 64 -OriginY 64 -Origin 4 -Color $ColorAfinidad[$e.Afi] -Label $e.Label
    $allSprites += $r1
    # Retrato
    $r2 = New-GMSprite -Name "spr_rostro_$($e.Id)" -Width 128 -Height 128 -OriginX 0 -OriginY 0 -Origin 0 -Color $ColorAfinidad[$e.Afi] -Label "ROSTRO`n$($e.Label.Split('`n')[0])"
    $allSprites += $r2
    Write-Host "  + spr_enemigo_$($e.Id) + spr_rostro_$($e.Id)" -ForegroundColor DarkGreen
}

# ────────────────────────────────────────────────────────────
# 4. ENEMIGOS ÉLITE — Cuerpo + Retrato (144x144, más grandes)
# ────────────────────────────────────────────────────────────
Write-Host "`n[4/9] Enemigos elite..." -ForegroundColor Green
foreach ($e in $enemigos_comunes) {
    $darkColor = @([Math]::Max(0, $ColorAfinidad[$e.Afi][0] - 40), [Math]::Max(0, $ColorAfinidad[$e.Afi][1] - 40), [Math]::Max(0, $ColorAfinidad[$e.Afi][2] - 40))
    # Cuerpo elite (ligeramente más grande)
    $r1 = New-GMSprite -Name "spr_elite_$($e.Id)" -Width 144 -Height 144 -OriginX 72 -OriginY 72 -Origin 4 -Color $darkColor -Label "ELITE`n$($e.Label.Split('`n')[0])"
    $allSprites += $r1
    # Retrato elite
    $r2 = New-GMSprite -Name "spr_rostro_elite_$($e.Id)" -Width 128 -Height 128 -OriginX 0 -OriginY 0 -Origin 0 -Color $darkColor -Label "ELITE`n$($e.Label.Split('`n')[0])"
    $allSprites += $r2
    Write-Host "  + spr_elite_$($e.Id) + spr_rostro_elite_$($e.Id)" -ForegroundColor DarkGreen
}

# ────────────────────────────────────────────────────────────
# 5. JEFES — Cuerpo (192x192) + Retrato (128x128)
# ────────────────────────────────────────────────────────────
Write-Host "`n[5/9] Jefes..." -ForegroundColor Green
$jefes = @(
    @{ Id = "titan_forjas";       Label = "TITAN`nFORJAS";       Afi = "Fuego" },
    @{ Id = "coloso_fango";       Label = "COLOSO`nFANGO";       Afi = "Planta" },
    @{ Id = "sentinela_cielo";    Label = "SENTINELA`nCIELO";    Afi = "Rayo" },
    @{ Id = "oraculo_abismo";     Label = "ORACULO`nABISMO";     Afi = "Sombra" },
    @{ Id = "devorador";          Label = "EL`nDEVORADOR";       Afi = "Neutro" },
    @{ Id = "primer_conductor";   Label = "PRIMER`nCONDUCTOR";   Afi = "Neutro" }
)
foreach ($j in $jefes) {
    $r1 = New-GMSprite -Name "spr_jefe_$($j.Id)" -Width 192 -Height 192 -OriginX 96 -OriginY 96 -Origin 4 -Color $ColorAfinidad[$j.Afi] -Label $j.Label
    $allSprites += $r1
    $r2 = New-GMSprite -Name "spr_rostro_$($j.Id)" -Width 128 -Height 128 -OriginX 0 -OriginY 0 -Origin 0 -Color $ColorAfinidad[$j.Afi] -Label "ROSTRO`n$($j.Label.Split('`n')[0])"
    $allSprites += $r2
    Write-Host "  + spr_jefe_$($j.Id) + spr_rostro_$($j.Id)" -ForegroundColor DarkGreen
}

# ────────────────────────────────────────────────────────────
# 6. FONDOS DE ROOMS (1280x720)
# ────────────────────────────────────────────────────────────
Write-Host "`n[6/9] Fondos de rooms..." -ForegroundColor Green
$fondos = @(
    @{ Name = "spr_bg_menu";          Label = "BG MENU";          Color = @(20, 15, 30) },
    @{ Name = "spr_bg_combate";       Label = "BG COMBATE";       Color = @(30, 20, 20) },
    @{ Name = "spr_bg_select";        Label = "BG SELECT";        Color = @(15, 20, 35) },
    @{ Name = "spr_bg_enemy_select";  Label = "BG ENEMY SELECT";  Color = @(35, 15, 15) },
    @{ Name = "spr_bg_forja";         Label = "BG FORJA";         Color = @(40, 25, 10) },
    @{ Name = "spr_bg_tienda";        Label = "BG TIENDA";        Color = @(20, 30, 20) },
    @{ Name = "spr_bg_torre";         Label = "BG TORRE";         Color = @(25, 15, 35) }
)
foreach ($f in $fondos) {
    $r = New-GMSprite -Name $f.Name -Width 1280 -Height 720 -OriginX 0 -OriginY 0 -Origin 0 -Color $f.Color -Label $f.Label
    $allSprites += $r
    Write-Host "  + $($f.Name)" -ForegroundColor DarkGreen
}

# ────────────────────────────────────────────────────────────
# 7. ICONOS UI — Habilidades, Estados, Objetos, Rúnicos (32x32)
# ────────────────────────────────────────────────────────────
Write-Host "`n[7/9] Iconos UI..." -ForegroundColor Green

# Iconos de estados alterados
$estados_icons = @(
    @{ Name = "spr_ico_quemadura";       Label = "BURN";  Color = $ColorAfinidad["Fuego"] },
    @{ Name = "spr_ico_veneno";          Label = "PSN";   Color = @(100, 180, 30) },
    @{ Name = "spr_ico_regeneracion";    Label = "REGEN"; Color = @(30, 200, 80) },
    @{ Name = "spr_ico_muro_tierra";     Label = "MURO";  Color = $ColorAfinidad["Tierra"] },
    @{ Name = "spr_ico_aceleracion";     Label = "ACEL";  Color = $ColorAfinidad["Rayo"] },
    @{ Name = "spr_ico_ralentizacion";   Label = "SLOW";  Color = @(80, 130, 200) },
    @{ Name = "spr_ico_vulnerabilidad";  Label = "VULN";  Color = $ColorAfinidad["Sombra"] },
    @{ Name = "spr_ico_supresion";       Label = "SUPR";  Color = $ColorAfinidad["Arcano"] }
)
foreach ($i in $estados_icons) {
    $r = New-GMSprite -Name $i.Name -Width 32 -Height 32 -OriginX 0 -OriginY 0 -Origin 0 -Color $i.Color -Label $i.Label
    $allSprites += $r
    Write-Host "  + $($i.Name)" -ForegroundColor DarkGreen
}

# Iconos de objetos consumibles
$objetos_icons = @(
    @{ Name = "spr_ico_pocion_basica";     Label = "HP+";   Color = @(200, 50, 50) },
    @{ Name = "spr_ico_pocion_media";      Label = "HP++";  Color = @(220, 80, 80) },
    @{ Name = "spr_ico_elixir_esencia";    Label = "ESNC";  Color = @(50, 180, 220) },
    @{ Name = "spr_ico_tonico_ataque";     Label = "ATK+";  Color = @(220, 120, 30) },
    @{ Name = "spr_ico_tonico_defensa";    Label = "DEF+";  Color = @(60, 140, 200) }
)
foreach ($i in $objetos_icons) {
    $r = New-GMSprite -Name $i.Name -Width 32 -Height 32 -OriginX 0 -OriginY 0 -Origin 0 -Color $i.Color -Label $i.Label
    $allSprites += $r
    Write-Host "  + $($i.Name)" -ForegroundColor DarkGreen
}

# Iconos de rúnicos
$runicos_icons = @(
    @{ Name = "spr_ico_runa_furia";           Label = "FURY";  Color = @(200, 30, 30) },
    @{ Name = "spr_ico_runa_fortaleza";       Label = "FORT";  Color = @(40, 120, 180) },
    @{ Name = "spr_ico_runa_celeridad";       Label = "CELD";  Color = @(40, 200, 200) },
    @{ Name = "spr_ico_runa_ultimo_aliento";  Label = "ULTI";  Color = @(180, 180, 180) },
    @{ Name = "spr_ico_runa_vampirica";       Label = "VAMP";  Color = @(140, 20, 60) },
    @{ Name = "spr_ico_runa_cristal";         Label = "CRST";  Color = @(180, 220, 240) }
)
foreach ($i in $runicos_icons) {
    $r = New-GMSprite -Name $i.Name -Width 32 -Height 32 -OriginX 0 -OriginY 0 -Origin 0 -Color $i.Color -Label $i.Label
    $allSprites += $r
    Write-Host "  + $($i.Name)" -ForegroundColor DarkGreen
}

# Iconos de habilidad (slots genéricos)
$hab_icons = @(
    @{ Name = "spr_ico_hab_clase";    Label = "E";    Color = @(180, 160, 40) },
    @{ Name = "spr_ico_hab_arma_1";   Label = "SPC";  Color = @(60, 140, 200) },
    @{ Name = "spr_ico_hab_arma_2";   Label = "Q";    Color = @(80, 160, 80) },
    @{ Name = "spr_ico_hab_arma_3";   Label = "W";    Color = @(160, 80, 160) },
    @{ Name = "spr_ico_super";        Label = "TAB";  Color = @(220, 180, 40) }
)
foreach ($i in $hab_icons) {
    $r = New-GMSprite -Name $i.Name -Width 48 -Height 48 -OriginX 0 -OriginY 0 -Origin 0 -Color $i.Color -Label $i.Label
    $allSprites += $r
    Write-Host "  + $($i.Name)" -ForegroundColor DarkGreen
}

# Iconos de afinidad
Write-Host "`n[8/9] Iconos de afinidad..." -ForegroundColor Green
$afinidades = @("Fuego", "Agua", "Planta", "Rayo", "Tierra", "Sombra", "Luz", "Arcano")
foreach ($a in $afinidades) {
    $r = New-GMSprite -Name "spr_ico_afinidad_$($a.ToLower())" -Width 32 -Height 32 -OriginX 0 -OriginY 0 -Origin 0 -Color $ColorAfinidad[$a] -Label $a.Substring(0, [Math]::Min(4, $a.Length)).ToUpper()
    $allSprites += $r
    Write-Host "  + spr_ico_afinidad_$($a.ToLower())" -ForegroundColor DarkGreen
}

# ────────────────────────────────────────────────────────────
# 8. UI GENERAL (barras, marcos, botones)
# ────────────────────────────────────────────────────────────
Write-Host "`n[9/9] UI general..." -ForegroundColor Green
$ui_sprites = @(
    @{ Name = "spr_barra_vida";       W = 256; H = 20;  Label = "HP BAR";     Color = @(40, 160, 40) },
    @{ Name = "spr_barra_vida_bg";    W = 256; H = 20;  Label = "HP BAR BG";  Color = @(40, 40, 40) },
    @{ Name = "spr_barra_esencia";    W = 256; H = 16;  Label = "ESENCIA";    Color = @(50, 140, 220) },
    @{ Name = "spr_barra_esencia_bg"; W = 256; H = 16;  Label = "ESENCIA BG"; Color = @(30, 30, 50) },
    @{ Name = "spr_barra_cooldown";   W = 48;  H = 48;  Label = "CD";         Color = @(30, 30, 30) },
    @{ Name = "spr_marco_retrato";    W = 136; H = 136; Label = "MARCO";      Color = @(80, 80, 120) },
    @{ Name = "spr_logo_arcadium";    W = 512; H = 256; Label = "ARCADIUM`nLOGO"; Color = @(20, 15, 40) },
    @{ Name = "spr_boton_menu";       W = 200; H = 48;  Label = "BOTON";      Color = @(40, 40, 60) },
    @{ Name = "spr_slot_objeto";      W = 48;  H = 48;  Label = "SLOT";       Color = @(50, 50, 70) },
    @{ Name = "spr_slot_runa";        W = 48;  H = 48;  Label = "RUNA";       Color = @(70, 40, 70) },
    @{ Name = "spr_cursor_select";    W = 32;  H = 32;  Label = ">";          Color = @(220, 200, 40) },
    @{ Name = "spr_panel_info";       W = 300; H = 200; Label = "INFO PANEL"; Color = @(20, 20, 35) }
)
foreach ($u in $ui_sprites) {
    $r = New-GMSprite -Name $u.Name -Width $u.W -Height $u.H -OriginX 0 -OriginY 0 -Origin 0 -Color $u.Color -Label $u.Label
    $allSprites += $r
    Write-Host "  + $($u.Name)" -ForegroundColor DarkGreen
}

# ────────────────────────────────────────────────────────────
# 9. EFECTOS DE COMBATE (64x64, origen centro)
# ────────────────────────────────────────────────────────────
$fx_sprites = @(
    @{ Name = "spr_fx_impacto";     Label = "HIT";    Color = @(255, 200, 60) },
    @{ Name = "spr_fx_critico";     Label = "CRIT!";  Color = @(255, 80, 30) },
    @{ Name = "spr_fx_curacion";    Label = "HEAL";   Color = @(60, 220, 100) },
    @{ Name = "spr_fx_esquiva";     Label = "MISS";   Color = @(160, 160, 160) },
    @{ Name = "spr_fx_esencia";     Label = "ESCN";   Color = @(80, 180, 255) },
    @{ Name = "spr_fx_super";       Label = "SUPER";  Color = @(255, 220, 40) }
)
foreach ($fx in $fx_sprites) {
    $r = New-GMSprite -Name $fx.Name -Width 64 -Height 64 -OriginX 32 -OriginY 32 -Origin 4 -Color $fx.Color -Label $fx.Label
    $allSprites += $r
    Write-Host "  + $($fx.Name)" -ForegroundColor DarkGreen
}

# ============================================================
# ACTUALIZAR .yyp — Agregar todos los sprites al proyecto
# ============================================================
Write-Host "`n=== ACTUALIZANDO PROYECTO .yyp ===" -ForegroundColor Cyan

$yypPath = "$ProjectRoot\RogueLites.yyp"
$yypContent = Get-Content -Path $yypPath -Raw -Encoding UTF8

# Generar las líneas de recursos
$resourceLines = ""
foreach ($s in $allSprites) {
    $resourceLines += "    {`"id`":{`"name`":`"$($s.Name)`",`"path`":`"$($s.Path)`",},},`n"
}

# Insertar antes del cierre del array de resources (antes de la última línea que empieza con "  ],")
# Buscar el último sprite existente y agregar después
$insertMarker = '{"id":{"name":"spr_jugador","path":"sprites/spr_jugador/spr_jugador.yy",},},'
$yypContent = $yypContent -replace [regex]::Escape($insertMarker), "$insertMarker`n$resourceLines"

Set-Content -Path $yypPath -Value $yypContent -Encoding UTF8

# ============================================================
# RESUMEN FINAL
# ============================================================
Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "  SPRITES GENERADOS: $($allSprites.Count)" -ForegroundColor White
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# Desglose
$cat = @{
    "Personajes (cuerpo)"   = ($allSprites | Where-Object { $_.Name -match "^spr_jugador_" }).Count
    "Personajes (retrato)"  = ($allSprites | Where-Object { $_.Name -match "^spr_rostro_(kael|lys|torvan|maelis|saren|nerya|thalys|brenn)$" }).Count
    "Enemigos comunes"      = ($allSprites | Where-Object { $_.Name -match "^spr_enemigo_" }).Count
    "Enemigos (retratos)"   = ($allSprites | Where-Object { $_.Name -match "^spr_rostro_(soldado|vigia|halito|bestia|guardian|naufrago|paladin|errante)" }).Count
    "Elites (cuerpo)"       = ($allSprites | Where-Object { $_.Name -match "^spr_elite_" }).Count
    "Elites (retrato)"      = ($allSprites | Where-Object { $_.Name -match "^spr_rostro_elite_" }).Count
    "Jefes (cuerpo)"        = ($allSprites | Where-Object { $_.Name -match "^spr_jefe_" }).Count
    "Jefes (retrato)"       = ($allSprites | Where-Object { $_.Name -match "^spr_rostro_(titan|coloso|sentinela|oraculo|devorador|primer)" }).Count
    "Fondos de room"        = ($allSprites | Where-Object { $_.Name -match "^spr_bg_" }).Count
    "Iconos estados"        = ($allSprites | Where-Object { $_.Name -match "^spr_ico_(quemadura|veneno|regen|muro|aceler|ralent|vulner|supres)" }).Count
    "Iconos objetos"        = ($allSprites | Where-Object { $_.Name -match "^spr_ico_(pocion|elixir|tonico)" }).Count
    "Iconos rúnicos"        = ($allSprites | Where-Object { $_.Name -match "^spr_ico_runa_" }).Count
    "Iconos habilidades"    = ($allSprites | Where-Object { $_.Name -match "^spr_ico_hab_|^spr_ico_super" }).Count
    "Iconos afinidad"       = ($allSprites | Where-Object { $_.Name -match "^spr_ico_afinidad_" }).Count
    "UI general"            = ($allSprites | Where-Object { $_.Name -match "^spr_(barra|marco|logo|boton|slot|cursor|panel)" }).Count
    "Efectos combate"       = ($allSprites | Where-Object { $_.Name -match "^spr_fx_" }).Count
}

foreach ($k in $cat.Keys | Sort-Object) {
    Write-Host ("  {0,-25} {1,3}" -f $k, $cat[$k]) -ForegroundColor Gray
}

Write-Host "`n  TOTAL: $($allSprites.Count) sprites" -ForegroundColor White
Write-Host "`nListo. Abre GameMaker, recarga el proyecto y todos los sprites aparecerán." -ForegroundColor Yellow
