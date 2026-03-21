# ==============================================================================
#  ASCII Art
# ==============================================================================

$scriptTitle = (Get-Item $PSCommandPath).BaseName

$HeaderArt = @"
	  ___________________________________
	 /...................................\
	 |:                                 :|           Thank you to the ArkOS Wiki Page.
	 |:                                 :|           
	 |:       R36S  FILE  MANAGER       :|           Thank you to the Handheld community.
	 |:             $scriptTitle              :|
	 |:          "The Vortex"           :|           
	 |:                                 :|           I Thank God for this day
	 |:                                 :|           for the sun in the sky
	 |:                                 :|           for my mom and my dad
	 |:                                 :|           and my piece of apple pie
	 |:                                 :|
	 |:           jj1eckhardt           :|
	 |:.................................:|
	 |              __ . __              |
	 |      __      . ___ .              |
	 |     |  |     __ . __    ( X )     |
	 |  ___|  |___                       |
	 | |          |        ( Y )   ( A ) |
 	 | |___    ___|                      |
	 |     |  |       mnu      ( B )     |
	 |     |__|      ( M )               |
	 |            ( S ) ( S )            |
	 |     ___   select start    ___     |
	 |    /   \                 /   \    |
	 |   {     }               {     }   |
	 |    \___/                 \___/    |
	 \___________________________________/	
"@

# To display it in the console during launch:
Write-Host $HeaderArt -ForegroundColor Cyan


# ==============================================================================
#
# ==============================================================================
# SECTION 1: SYSTEM INITIALIZATION & GLOBAL CORE
# ==============================================================================

# --- 1.1: REQUIRED ASSEMBLIES & UI ENGINE ---
# These MUST be at the top. They load the "dictionary" PowerShell uses for Windows.
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# This line ensures the buttons look like modern Windows buttons, not 1995 style.
[System.Windows.Forms.Application]::EnableVisualStyles()

# (Optional) Forces PowerShell to use modern security for the GitHub link
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# --- 1.2: GLOBAL CONFIGURATIONS ---
# These variables control the behavior of Sync and Scan throughout the script
$global:RomExtensions = @(".zip",".7z",".iso",".chd",".bin",".cue",".dosz",".gba",".gbc",".gb",".nes",".sfc",".smc",".n64",".pbp",".nds",".vmu",".img",".fds",".md",".gen",".p8",".sh",".png",".ldb",".mgw",".mp4",".avi",".mov",".mpg",".mpeg",".wmv",".mkv",".mp3",".ogg",".webm",".wav"".flac",".rtf",".rom",".pup",".pce",".jar",".ini",".dat"".lo",".srm",",sig",".s12")
$global:SourcePath    = ""
$global:DestPath      = ""
$global:AbortSync     = $false

# --- 1.3: MASTER SYSTEM DATABASE (Rows 1-140) ---
# The source of truth for folder names and aliases across all OS variants
$global:SystemDatabase = @(

[PSCustomObject]@{ID=1     ;Name="3DO"                     ;Folder="3do"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="1"},      
[PSCustomObject]@{ID=2     ;Name="Entex Adventure Vision"  ;Folder="advision"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="2"},      
[PSCustomObject]@{ID=3     ;Name="American Laser Games"    ;Folder="alg"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="3"},      
[PSCustomObject]@{ID=4     ;Name="Amiga"                   ;Folder="amiga"            ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="4"},      
[PSCustomObject]@{ID=5     ;Name="Amiga CD32"              ;Folder="amigacd32"        ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="5"},      
[PSCustomObject]@{ID=6     ;Name="Amstrad CPC"             ;Folder="amstradcpc"       ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="6"},      
[PSCustomObject]@{ID=7     ;Name="Apple II"                ;Folder="apple2"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="7"},      
[PSCustomObject]@{ID=8     ;Name="Arcade"                  ;Folder="arcade"           ;Alias="mame"        ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="8"},      
[PSCustomObject]@{ID=9     ;Name="Arduboy"                 ;Folder="arduboy"          ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="9"},      
[PSCustomObject]@{ID=10    ;Name="Astrocade"               ;Folder="astrocde"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="10"},     
[PSCustomObject]@{ID=11    ;Name="Atari 2600"              ;Folder="atari2600"        ;Alias="atari"       ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="11"},     
[PSCustomObject]@{ID=12    ;Name="Atari 5200"              ;Folder="atari5200"        ;Alias="a5200"       ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="12"},     
[PSCustomObject]@{ID=13    ;Name="Atari 7800"              ;Folder="atari7800"        ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="13"},     
[PSCustomObject]@{ID=14    ;Name="Atari 800"               ;Folder="atari800"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="14"},     
[PSCustomObject]@{ID=15    ;Name="Atari Jaguar"            ;Folder="atarijaguar"      ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="15"},     
[PSCustomObject]@{ID=16    ;Name="Atari Lynx"              ;Folder="atarilynx"        ;Alias="lynx"        ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="16"},     
[PSCustomObject]@{ID=17    ;Name="Atari ST"                ;Folder="atarist"          ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="17"},     
[PSCustomObject]@{ID=18    ;Name="Atari XEGS"              ;Folder="atarixegs"        ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="18"},     
[PSCustomObject]@{ID=19    ;Name="Sammy Atomiswave"        ;Folder="atomiswave"       ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="19"},     
[PSCustomObject]@{ID=20    ;Name="Backup Storage"          ;Folder="backup"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="20"},     
[PSCustomObject]@{ID=21    ;Name="BBC Micro"               ;Folder="bbcmicro"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="21"},     
[PSCustomObject]@{ID=22    ;Name="Background Music"        ;Folder="bgmusic"          ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="22"},     
[PSCustomObject]@{ID=23    ;Name="System BIOS"             ;Folder="bios"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="23"},     
[PSCustomObject]@{ID=24    ;Name="Commodore 128"           ;Folder="c128"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="24"},     
[PSCustomObject]@{ID=25    ;Name="Commodore 16"            ;Folder="c16"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="25"},     
[PSCustomObject]@{ID=26    ;Name="Commodore 64"            ;Folder="c64"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="26"},     
[PSCustomObject]@{ID=27    ;Name="Cave Story"              ;Folder="cavestory"        ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="27"},     
[PSCustomObject]@{ID=27.1  ;Name="Philips CD-i"            ;Folder="cdimono1"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$false   ;dArkOS=$true    ;RE_ID="27.1"},   
[PSCustomObject]@{ID=28    ;Name="Fairchild Channel F"     ;Folder="channelf"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="28"},     
[PSCustomObject]@{ID=29    ;Name="Tandy CoCo 3"            ;Folder="coco3"            ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="29"},     
[PSCustomObject]@{ID=30    ;Name="ColecoVision"            ;Folder="coleco"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="30"},     
[PSCustomObject]@{ID=31    ;Name="CPS 1"                   ;Folder="cps1"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="31"},     
[PSCustomObject]@{ID=32    ;Name="CPS 2"                   ;Folder="cps2"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="32"},     
[PSCustomObject]@{ID=33    ;Name="CPS 3"                   ;Folder="cps3"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="33"},     
[PSCustomObject]@{ID=34    ;Name="Daphne"                  ;Folder="daphne"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="34"},     
[PSCustomObject]@{ID=35    ;Name="Doom"                    ;Folder="doom"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="35"},     
[PSCustomObject]@{ID=36    ;Name="PC (MS-DOS)"             ;Folder="dos"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="36"},     
[PSCustomObject]@{ID=37    ;Name="Dragon 32/64"            ;Folder="dragon32"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="37"},     
[PSCustomObject]@{ID=38    ;Name="Dreamcast"               ;Folder="dreamcast"        ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="38"},     
[PSCustomObject]@{ID=39    ;Name="EasyRPG"                 ;Folder="easyrpg"          ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="39"},     
[PSCustomObject]@{ID=40    ;Name="Enterprise 64/128"       ;Folder="enterprise"       ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="40"},     
[PSCustomObject]@{ID=41    ;Name="Famicom"                 ;Folder="famicom"          ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="41"},     
[PSCustomObject]@{ID=41.2  ;Name="Final Burn Neo"          ;Folder="fbneo"            ;Alias="---"         ;G350_Src="fbneo"            ;ArkOS=$false   ;dArkOS=$false   ;RE_ID="41.2"},   
[PSCustomObject]@{ID=42    ;Name="Famicom Disk System"     ;Folder="fds"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="42"},     
[PSCustomObject]@{ID=43    ;Name="Game and Watch"          ;Folder="gameandwatch"     ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="43"},     
[PSCustomObject]@{ID=44    ;Name="Game Gear"               ;Folder="gamegear"         ;Alias="gg"          ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="44"},     
[PSCustomObject]@{ID=44.1  ;Name="Game Tank"               ;Folder="gametank"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$false   ;dArkOS=$true    ;RE_ID="44.1"},   
[PSCustomObject]@{ID=45    ;Name="Nintendo Game Boy"       ;Folder="gb"               ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="45"},     
[PSCustomObject]@{ID=46    ;Name="Game Boy Advance"        ;Folder="gba"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="46"},     
[PSCustomObject]@{ID=47    ;Name="Game Boy Color"          ;Folder="gbc"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="47"},     
[PSCustomObject]@{ID=48    ;Name="Genesis/Megadrive"       ;Folder="genesis"          ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="48"},     
[PSCustomObject]@{ID=49    ;Name="Amstrad GX4000"          ;Folder="gx4000"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="49"},     
[PSCustomObject]@{ID=50    ;Name="Intellivision"           ;Folder="intellivision"    ;Alias="intv"        ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="50"},     
[PSCustomObject]@{ID=51    ;Name="Java (FreeJ2ME)"         ;Folder="j2me"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="51"},       
[PSCustomObject]@{ID=52    ;Name="Launch Images"           ;Folder="launchimages"     ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="52"},     
[PSCustomObject]@{ID=53    ;Name="Love2d"                  ;Folder="love2d"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="53"},     
[PSCustomObject]@{ID=54    ;Name="LowRes NX"               ;Folder="lowresnx"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="54"},     
[PSCustomObject]@{ID=55    ;Name="Mame/Mame 2010"          ;Folder="mame"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="55"},     
[PSCustomObject]@{ID=56    ;Name="Mame 2003"               ;Folder="mame2003"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="56"},     
[PSCustomObject]@{ID=57    ;Name="Master System"           ;Folder="mastersystem"     ;Alias="sms"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="57"},     
[PSCustomObject]@{ID=58    ;Name="Sega Mega Drive"         ;Folder="megadrive"        ;Alias="genesis"     ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="58"},     
[PSCustomObject]@{ID=58.2  ;Name="Mega Drive Japan"        ;Folder="megadrive-japan"  ;Alias="---"         ;G350_Src="megadrive-japan"  ;ArkOS=$false   ;dArkOS=$false   ;RE_ID="58.2"},   
[PSCustomObject]@{ID=59    ;Name="Mega Duck"               ;Folder="megaduck"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="59"},     
[PSCustomObject]@{ID=60    ;Name="Movie Player"            ;Folder="movies"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="60"},     
[PSCustomObject]@{ID=61    ;Name="Megadrive MSU"           ;Folder="msumd"            ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="61"},     
[PSCustomObject]@{ID=62    ;Name="MSX"                     ;Folder="msx"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="62"},     
[PSCustomObject]@{ID=63    ;Name="MSX2"                    ;Folder="msx2"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="63"},     
[PSCustomObject]@{ID=63.1  ;Name="Music Path"              ;Folder="music"            ;Alias="---"         ;G350_Src="---"              ;ArkOS=$false   ;dArkOS=$true    ;RE_ID="63.1"},   
[PSCustomObject]@{ID=64    ;Name="Microvision"             ;Folder="mv"               ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="64"},     
[PSCustomObject]@{ID=65    ;Name="Nintendo 64"             ;Folder="n64"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="65"},     
[PSCustomObject]@{ID=66    ;Name="Nintendo 64DD"           ;Folder="n64dd"            ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="66"},     
[PSCustomObject]@{ID=67    ;Name="Naomi"                   ;Folder="naomi"            ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="67"},     
[PSCustomObject]@{ID=68    ;Name="Nintendo DS"             ;Folder="nds"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="68"},     
[PSCustomObject]@{ID=69    ;Name="Neo Geo"                 ;Folder="neogeo"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="69"},     
[PSCustomObject]@{ID=70    ;Name="Neo Geo CD"              ;Folder="neogeocd"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="70"},     
[PSCustomObject]@{ID=71    ;Name="Nintendo NES"            ;Folder="nes"              ;Alias="fc"          ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="71"},     
[PSCustomObject]@{ID=72    ;Name="Neo Geo Pocket"          ;Folder="ngp"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="72"},     
[PSCustomObject]@{ID=73    ;Name="Neo Geo Pocket Color"    ;Folder="ngpc"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="73"},     
[PSCustomObject]@{ID=74    ;Name="Magnavox Odyssey 2"      ;Folder="odyssey2"         ;Alias="o2"          ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="74"},     
[PSCustomObject]@{ID=75    ;Name="Visual Novel Engine"     ;Folder="onscripter"       ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="75"},     
[PSCustomObject]@{ID=76    ;Name="OpenBOR"                 ;Folder="openbor"          ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="76"},     
[PSCustomObject]@{ID=77    ;Name="Palm OS"                 ;Folder="palm"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="77"},     
[PSCustomObject]@{ID=78    ;Name="PC98"                    ;Folder="pc98"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="78"},     
[PSCustomObject]@{ID=79    ;Name="PC Engine"               ;Folder="pcengine"         ;Alias="pce"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="79"},     
[PSCustomObject]@{ID=80    ;Name="PC Engine CD"            ;Folder="pcenginecd"       ;Alias="pcecd"       ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="80"},     
[PSCustomObject]@{ID=81    ;Name="PC-FX"                   ;Folder="pcfx"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="81"},     
[PSCustomObject]@{ID=82    ;Name="Sega Pico"               ;Folder="pico"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="82"},     
[PSCustomObject]@{ID=83    ;Name="PICO-8"                  ;Folder="pico-8"           ;Alias="pico8"       ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="83"},     
[PSCustomObject]@{ID=84    ;Name="Aquaplus P/ECE"          ;Folder="piece"            ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="84"},     
[PSCustomObject]@{ID=85    ;Name="Pokemon Mini"            ;Folder="pokemonmini"      ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="85"},     
[PSCustomObject]@{ID=86    ;Name="Ports"                   ;Folder="ports"            ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="86"},     
[PSCustomObject]@{ID=87    ;Name="PS Portable (PSP)"       ;Folder="psp"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="87"},     
[PSCustomObject]@{ID=87.2  ;Name="PSP Configs/Saves"       ;Folder="psp/ppsspp"       ;Alias="---"         ;G350_Src="ppsspp"           ;ArkOS=$false   ;dArkOS=$false   ;RE_ID="87.2"},   
[PSCustomObject]@{ID=88    ;Name="PSP Minis"               ;Folder="pspminis"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="88"},     
[PSCustomObject]@{ID=89    ;Name="Playstation 1"           ;Folder="psx"              ;Alias="ps1"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="89"},     
[PSCustomObject]@{ID=90    ;Name="PuzzleScript"            ;Folder="puzzlescript"     ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="90"},     
[PSCustomObject]@{ID=91    ;Name="Satellaview"             ;Folder="satellaview"      ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="91"},     
[PSCustomObject]@{ID=92    ;Name="Sega Saturn"             ;Folder="saturn"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="92"},     
[PSCustomObject]@{ID=93    ;Name="ScummVM"                 ;Folder="scummvm"          ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="93"},     
[PSCustomObject]@{ID=94    ;Name="Super Cassette Vision"   ;Folder="scv"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="94"},     
[PSCustomObject]@{ID=95    ;Name="Sega 32X"                ;Folder="sega32x"          ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="95"},     
[PSCustomObject]@{ID=96    ;Name="Sega CD"                 ;Folder="segacd"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="96"},     
[PSCustomObject]@{ID=97    ;Name="(SNES)/(SFC)"            ;Folder="sfc"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="97"},     
[PSCustomObject]@{ID=98    ;Name="SG 1000"                 ;Folder="sg-1000"          ;Alias="sg1000"      ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="98"},     
[PSCustomObject]@{ID=99    ;Name="Super Game Boy"          ;Folder="sgb"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="99"},     
[PSCustomObject]@{ID=100   ;Name="Super Nintendo"          ;Folder="snes"             ;Alias="sfc"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="100"},    
[PSCustomObject]@{ID=101   ;Name="Super Nintendo Hacks"    ;Folder="snes-hacks"       ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="101"},    
[PSCustomObject]@{ID=102   ;Name="Super Nintendo MSU1"     ;Folder="snesmsu1"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="102"},    
[PSCustomObject]@{ID=103   ;Name="Solarus"                 ;Folder="solarus"          ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="103"},    
[PSCustomObject]@{ID=104   ;Name="SuFami Turbo"            ;Folder="sufami"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="104"},    
[PSCustomObject]@{ID=105   ;Name="Super Grafx"             ;Folder="supergrafx"       ;Alias="sgfx"        ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="105"},    
[PSCustomObject]@{ID=106   ;Name="Watara Supervision"      ;Folder="supervision"      ;Alias="sv"          ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="106"},    
[PSCustomObject]@{ID=107   ;Name="System Themes"           ;Folder="themes"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="107"},    
[PSCustomObject]@{ID=108   ;Name="Thomson MO/TO"           ;Folder="thomson"          ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="108"},    
[PSCustomObject]@{ID=109   ;Name="TI-99/4A"                ;Folder="ti99"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="109"},    
[PSCustomObject]@{ID=110   ;Name="TIC-80"                  ;Folder="tic80"            ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="110"},    
[PSCustomObject]@{ID=110.1 ;Name="Tiger LCD"               ;Folder="tigerlcd"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$false   ;dArkOS=$true    ;RE_ID="110.1"},  
[PSCustomObject]@{ID=111   ;Name="ArkOS Tools"             ;Folder="tools"            ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="111"},    
[PSCustomObject]@{ID=112   ;Name="TurboGrafx-16"           ;Folder="turbografx"       ;Alias="pcengine"    ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="112"},    
[PSCustomObject]@{ID=113   ;Name="TurboGrafx-CD"           ;Folder="turbografxcd"     ;Alias="pcenginecd"  ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="113"},    
[PSCustomObject]@{ID=114   ;Name="Videoton TV-Computer"    ;Folder="tvc"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="114"},    
[PSCustomObject]@{ID=115   ;Name="Uzebox"                  ;Folder="uzebox"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="115"},
[PSCustomObject]@{ID=115.2 ;Name="Verticle Arcade"         ;Folder="varcade"          ;Alias="---"         ;G350_Src="varcade"          ;ArkOS=$false   ;dArkOS=$false   ;RE_ID="115.2"},    
[PSCustomObject]@{ID=116   ;Name="Vectrex"                 ;Folder="vectrex"          ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="116"},    
[PSCustomObject]@{ID=117   ;Name="Commodore Vic-20"        ;Folder="vic20"            ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="117"},    
[PSCustomObject]@{ID=117.1 ;Name="Videopac"                ;Folder="videopac"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$false   ;dArkOS=$true    ;RE_ID="117.1"},  
[PSCustomObject]@{ID=118   ;Name="System Videos"           ;Folder="videos"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="118"},    
[PSCustomObject]@{ID=119   ;Name="Vircon32"                ;Folder="vircon32"         ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="119"},    
[PSCustomObject]@{ID=120   ;Name="Virtual Boy"             ;Folder="virtualboy"       ;Alias="vb"          ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="120"},    
[PSCustomObject]@{ID=121   ;Name="Apple Macintosh"         ;Folder="vmac"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="121"},    
[PSCustomObject]@{ID=122   ;Name="Dreamcast VMU"           ;Folder="vmu"              ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="122"},    
[PSCustomObject]@{ID=123   ;Name="WASM-4"                  ;Folder="wasm4"            ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="123"},    
[PSCustomObject]@{ID=124   ;Name="Wolfenstein 3D"          ;Folder="wolf"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="124"},    
[PSCustomObject]@{ID=124.2 ;Name="Half-Life (Xash3D)"      ;Folder="ports/xash3d"     ;Alias="---"         ;G350_Src="xash3d_fwgs"      ;ArkOS=$false   ;dArkOS=$false   ;RE_ID="124.2"},  
[PSCustomObject]@{ID=125   ;Name="WonderSwan"              ;Folder="wonderswan"       ;Alias="ws"          ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="125"},    
[PSCustomObject]@{ID=126   ;Name="WonderSwan Color"        ;Folder="wonderswancolor"  ;Alias="wsc"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="126"},    
[PSCustomObject]@{ID=127   ;Name="Sharp X1"                ;Folder="x1"               ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="127"},    
[PSCustomObject]@{ID=128   ;Name="Sharp X68000"            ;Folder="x68000"           ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="128"},    
[PSCustomObject]@{ID=129   ;Name="ZX-81"                   ;Folder="zx81"             ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="129"},    
[PSCustomObject]@{ID=130   ;Name="ZX Spectrum"             ;Folder="zxspectrum"       ;Alias="---"         ;G350_Src="---"              ;ArkOS=$true    ;dArkOS=$true    ;RE_ID="130"}

)

# --- 1.4: DATABASE OS-SPECIFIC FLAG and SPECIAL ADDITIONS LOGIC ---
# --- [PSCustomObject]@{ID=xx.1 = Indicates: dArkOS_RE_ID specific folders
# --- [PSCustomObject]@{ID=xx.2 = Indicates: G350_Src specific folders


# ==============================================================================
# ==============================================================================
# SECTION 2: UI FRAME & THEME
# ==============================================================================


# --- 2.1: MAIN WINDOW DEFINITION ---
# The primary container for the entire utility
$global:Form = New-Object System.Windows.Forms.Form
$global:Form.Size            = New-Object System.Drawing.Size(820, 950)
$global:Form.StartPosition   = "CenterScreen"
$global:Form.BackColor       = [System.Drawing.ColorTranslator]::FromHtml("#f0f0f0")
$global:Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$global:Form.MaximizeBox     = $false
$global:Form.SizeGripStyle   = [System.Windows.Forms.SizeGripStyle]::Hide

# --- 2.1.1: HEADER & TITLE ---
# This automatically grabs "vx.x.x" (or whatever you named the file)
$scriptTitle = (Get-Item $PSCommandPath).BaseName
# If you want to keep the "R36S File Manager" prefix:
$global:Form.Text = "R36S File Manager - $scriptTitle"

# --- 2.2: GLOBAL UI SCALING & THEME SETTINGS ---
# Set the icon (if you have one) or generic window properties here
# $global:Form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")

# --- 2.3: SYSTEM COLORS & BRUSHES ---
# Defining shared colors here makes it easier to change the look later
$global:ColorDarkPanel  = [System.Drawing.ColorTranslator]::FromHtml("#2d2d2d")
$global:ColorButtonGray = [System.Drawing.ColorTranslator]::FromHtml("#dcdcdc")
$global:ColorSyncBlue   = [System.Drawing.ColorTranslator]::FromHtml("#add8e6")
$global:ColorAbortRed   = [System.Drawing.ColorTranslator]::FromHtml("#FF0000")

# ==============================================================================
# SECTION 3: UI CONTROLS (Labels, Buttons, & Logs)
# ==============================================================================

# --- 3.0: HEADER HELP OBJECT ---
$global:lblHelpHint = New-Object System.Windows.Forms.LinkLabel
$global:lblHelpHint.Text      = "[?] How to use this tool" 
$global:lblHelpHint.Location  = New-Object System.Drawing.Point(15, 0) # Your requested X-coord
$global:lblHelpHint.Size      = New-Object System.Drawing.Size(160, 20)
$global:lblHelpHint.LinkColor = [System.Drawing.Color]::DimGray
$global:lblHelpHint.Font      = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)

$Form.Controls.Add($global:lblHelpHint)
$global:lblHelpHint.add_LinkClicked({ Show-HelpManual })


# --- 3.1: PATH SELECTION ROW (TOP) ---
$global:btnMaster = New-Object Windows.Forms.Button
$global:btnMaster.Text     = "1. Select MASTER (PC)"
$global:btnMaster.Location = New-Object System.Drawing.Point(30, 20)
$global:btnMaster.Size     = New-Object System.Drawing.Size(360, 45)
$global:btnMaster.BackColor = $global:ColorButtonGray

$global:btnSD = New-Object Windows.Forms.Button
$global:btnSD.Text     = "2. Select TARGET (SD/PC)"
$global:btnSD.Location = New-Object System.Drawing.Point(410, 20)
$global:btnSD.Size     = New-Object System.Drawing.Size(360, 45)
$global:btnSD.BackColor = $global:ColorButtonGray

# --- 3.2: STATUS DISPLAY (PATHs BOX) ---
$global:lblStatus = New-Object Windows.Forms.Label
$global:lblStatus.Text      = "Ready"
$global:lblStatus.Location  = New-Object System.Drawing.Point(30, 75)
$global:lblStatus.Size      = New-Object System.Drawing.Size(740, 45)
$global:lblStatus.TextAlign = "MiddleLeft"
$global:lblStatus.Font      = New-Object Drawing.Font("Consolas", 9)
$global:lblStatus.BackColor = $global:ColorDarkPanel
$global:lblStatus.ForeColor = [System.Drawing.Color]::White

# --- 3.3: RESET & SYNC ROW ---
$global:btnReset = New-Object Windows.Forms.Button
$global:btnReset.Text     = "RESET ALL SELECTIONS"
$global:btnReset.Location = New-Object System.Drawing.Point(30, 130)
$global:btnReset.Size     = New-Object System.Drawing.Size(740, 40)
$global:btnReset.BackColor = $global:ColorButtonGray
$global:btnReset.Font      = New-Object Drawing.Font("Segoe UI", 9, [Drawing.FontStyle]::Bold)

$global:btnSync = New-Object Windows.Forms.Button
$global:btnSync.Text     = "UNIVERSAL SYNC"
$global:btnSync.Location = New-Object System.Drawing.Point(30, 185)
$global:btnSync.Size     = New-Object System.Drawing.Size(295, 55)
$global:btnSync.BackColor = $global:ColorSyncBlue
$global:btnSync.Enabled  = $false

$global:btnAbort = New-Object Windows.Forms.Button
$global:btnAbort.Text     = "ABORT"
$global:btnAbort.Location = New-Object System.Drawing.Point(330, 185)
$global:btnAbort.Size     = New-Object System.Drawing.Size(65, 55)
$global:btnAbort.BackColor = $global:ColorAbortRed
$global:btnAbort.ForeColor = [System.Drawing.Color]::White
$global:btnAbort.Font      = New-Object Drawing.Font("Segoe UI", 10, [Drawing.FontStyle]::Bold)
$global:btnAbort.Enabled   = $false

$global:btnCleanup = New-Object Windows.Forms.Button
$global:btnCleanup.Text     = "CLEANUP (Mirror Mode)"
$global:btnCleanup.Location = New-Object System.Drawing.Point(405, 185)
$global:btnCleanup.Size     = New-Object System.Drawing.Size(365, 55)
$global:btnCleanup.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ffb6c1")
$global:btnCleanup.Enabled  = $false

# --- 3.4: OS GENERATION & TOOLS ---
$global:btnGenArk = New-Object Windows.Forms.Button
$global:btnGenArk.Text     = "GEN: ArkOS"
$global:btnGenArk.Location = New-Object System.Drawing.Point(30, 255)
$global:btnGenArk.Size     = New-Object System.Drawing.Size(180, 55)
$global:btnGenArk.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#99FF00")
$global:btnGenArk.Enabled     = $false

$global:btnGenDark = New-Object Windows.Forms.Button
$global:btnGenDark.Text     = "GEN: dArkOS"
$global:btnGenDark.Location = New-Object System.Drawing.Point(216, 255)
$global:btnGenDark.Size     = New-Object System.Drawing.Size(180, 55)
$global:btnGenDark.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#66FF00")
$global:btnGenDark.Enabled     = $false

$global:btnGenDarkRE = New-Object Windows.Forms.Button
$global:btnGenDarkRE.Text     = "GEN: dArkOS-RE"
$global:btnGenDarkRE.Location = New-Object System.Drawing.Point(402, 255)
$global:btnGenDarkRE.Size     = New-Object System.Drawing.Size(180, 55)
$global:btnGenDarkRE.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#33FF00")
$global:btnGenDarkRE.Enabled     = $false

$global:btnGenG350 = New-Object Windows.Forms.Button
$global:btnGenG350.Text     = "G350 Source"
$global:btnGenG350.Location = New-Object System.Drawing.Point(588, 255)
$global:btnGenG350.Size     = New-Object System.Drawing.Size(182, 55)
$global:btnGenG350.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ffeb3b")
$global:btnGenG350.Font      = New-Object Drawing.Font("Segoe UI", 9, [Drawing.FontStyle]::Bold)
$global:btnGenG350.Enabled    = $false

# --- 3.5: CLONE MODE GROUPBOX (Expanded & Aligned) ---
$global:gbCloneMode = New-Object Windows.Forms.GroupBox
$global:gbCloneMode.Text     = "Clone Mode Select"
$global:gbCloneMode.Location = New-Object System.Drawing.Point(405, 322) # Expanded leftward
$global:gbCloneMode.Size     = New-Object System.Drawing.Size(360, 57)  # Much wider, shorter height

# Left Side Column
$global:rbFoldersOnly = New-Object Windows.Forms.RadioButton
$global:rbFoldersOnly.Text     = "Folders Only"
$global:rbFoldersOnly.Location = New-Object System.Drawing.Point(10, 12)
$global:rbFoldersOnly.Checked  = $true

$global:rbEverything = New-Object Windows.Forms.RadioButton
$global:rbEverything.Text     = "EVERYTHING"
$global:rbEverything.Location = New-Object System.Drawing.Point(10, 31)

# Right Side Column (Inline with Folders)
$global:rbSystemOnly = New-Object Windows.Forms.RadioButton
$global:rbSystemOnly.Text     = "System Only (BIOS/Ports/Tools)"
$global:rbSystemOnly.Location = New-Object System.Drawing.Point(150, 12) # Moved to the right
$global:rbSystemOnly.AutoSize = $true

$global:gbCloneMode.Controls.AddRange(@($global:rbFoldersOnly, $global:rbEverything, $global:rbSystemOnly))

# --- 3.6: POWER CLONE BUTTON (Shrunk & Centered) ---
$global:btnPowerClone = New-Object Windows.Forms.Button
$global:btnPowerClone.Text      = "POWER CLONE"
$global:btnPowerClone.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#ffd700")
$global:btnPowerClone.ForeColor = [System.Drawing.Color]::White
$global:btnPowerClone.Font      = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)

# Sizing & Alignment
# We shrink it and center it relative to the RE button (which is likely at X=200ish)
$global:btnPowerClone.Size     = New-Object System.Drawing.Size(365, 55) 
$global:btnPowerClone.Location = New-Object System.Drawing.Point(30, 325) # Adjusted for the new center

# --- 3.6: MONITORING (PROGRESS & LOG) ---
$global:lblAction = New-Object Windows.Forms.Label
$global:lblAction.Text      = "Ready"
$global:lblAction.Location  = New-Object System.Drawing.Point(30, 455)
$global:lblAction.Size      = New-Object System.Drawing.Size(740, 25)
$global:lblAction.Font      = New-Object Drawing.Font("Consolas", 10)
$global:lblAction.Visible   = $false  # <--- HIDE UNTIL NEEDED

$global:ProgressBar = New-Object Windows.Forms.ProgressBar
$global:ProgressBar.Location = New-Object System.Drawing.Point(30, 480)
$global:ProgressBar.Size     = New-Object System.Drawing.Size(735, 25)
$global:ProgressBar.Visible  = $false  # <--- HIDE BY DEFAULT

$global:Log = New-Object Windows.Forms.TextBox
$global:Log.Multiline  = $true
$global:Log.ReadOnly   = $true
$global:Log.Location   = New-Object System.Drawing.Point(30, 520)
$global:Log.Size       = New-Object System.Drawing.Size(760, 350)
$global:Log.ScrollBars = "Vertical"
$global:Log.Font       = New-Object Drawing.Font("Consolas", 9)
$global:Log.BackColor  = $global:ColorDarkPanel
$global:Log.ForeColor  = [System.Drawing.Color]::White

# --- 3.7: FOOTER & GITHUB LINK ---
# The Big Audit Button
$global:btnAudit = New-Object System.Windows.Forms.Button
$global:btnAudit.Text     = "RUN FULL 130-SYSTEM AUDIT"
$global:btnAudit.Location = New-Object System.Drawing.Point(30, 395)
$global:btnAudit.Size     = New-Object System.Drawing.Size(740, 45)
$global:btnAudit.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#e0e0e0")
$global:btnAudit.Enabled   = $false # Keep disabled until paths are set

# --- 3.8: HEADER & TITLE ---
# Get the filename without the .ps1 extension
$scriptTitle = (Get-Item $PSCommandPath).BaseName 

$global:lblGitHub = New-Object System.Windows.Forms.LinkLabel
# Use single quotes around the whole string so the double quotes stay as text
$global:lblGitHub.Text     = 'ArkOS Utility - ' + $scriptTitle + ' | GitHub.com | Click for Updates'
$global:lblGitHub.Location = New-Object System.Drawing.Point(30, 890)
$global:lblGitHub.Size     = New-Object System.Drawing.Size(400, 20)
$global:lblGitHub.LinkColor = [System.Drawing.Color]::Gray
$global:lblGitHub.Font      = New-Object System.Drawing.Font("Segoe UI", 8, [System.Drawing.FontStyle]::Italic)

# Make the entire string clickable
$global:lblGitHub.LinkArea = New-Object System.Windows.Forms.LinkArea(0, $global:lblGitHub.Text.Length)

$Form.Controls.Add($global:lblHelpHint)

# ==============================================================================
# SECTION 4: THE ENGINE (Functions)
# ==============================================================================

# Function 4.1: Check if Master and Target paths are set
function Test-PathsReady {
    param([string]$ActionName)
    
    if ([string]::IsNullOrWhiteSpace($global:SourcePath) -or [string]::IsNullOrWhiteSpace($global:DestPath)) {
        $missing = if (!$global:SourcePath) { "MASTER (Source)" } else { "TARGET (SD/PC)" }
        [System.Windows.Forms.MessageBox]::Show("Please select a $missing folder before running: $ActionName", "Paths Not Set", [System.Windows.Forms.MessageBoxButtons]::OK, 
	  [System.Windows.Forms.MessageBoxIcon]::Warning)
        return $false
    }
    return $true
}

# Function 4.2: Universal Progress Bar & Dashboard Updater
function Update-UIProgress {
    param($BytesDone, $TotalBytes, $Stopwatch, $FileName)
    
    # --- 1. SAFETY: Prevent Divide by Zero ---
    if ($TotalBytes -le 0) { $percent = 0 } 
    else { $percent = [math]::Min(100, [int](($BytesDone / $TotalBytes) * 100)) }
    
    $global:ProgressBar.Value = $percent

    # --- 2. CALCULATE SPEED & ETA ---
    $elapsed = $Stopwatch.Elapsed.TotalSeconds
    
    # We only update the text every 0.2 seconds to prevent "flickering"
    if ($elapsed -gt 0.2) {
        $bps = $BytesDone / $elapsed
        $rem = if ($bps -gt 0) { ($TotalBytes - $BytesDone) / $bps } else { 0 }
        
        $speed      = [Math]::Round($bps / 1MB, 1)
        $remainStr  = [TimeSpan]::FromSeconds($rem).ToString("mm\:ss")
        $displayName = if ($FileName.Length -gt 25) { $FileName.Substring(0,22) + "..." } else { $FileName }

        # --- 3. UPDATE THE DASHBOARD ---
        # Using -f operator is safer than the colon-drive error
        $template = "Progress: {0,3}% | Speed: {1,5} MB/s | Left: {2,5} | {3}"
        $global:lblAction.Text = $template -f $percent, $speed, $remainStr, $displayName
        $global:lblAction.Visible = $true
    }
    
    # Keep UI responsive (important for ABORT button)
    [System.Windows.Forms.Application]::DoEvents()
}

# Function 4.3: Historical Logging Helper
function Update-Log {
    param([string]$Message, [bool]$Highlight = $false)
    
    $timestamp = Get-Date -Format "HH:mm:ss"
    $global:Log.AppendText("[$timestamp] > $Message`r`n")
    
    if ($Highlight) {
        $global:lblAction.Text = $Message
        $global:lblAction.Visible = $true
    }
    # Auto-scroll to bottom
    $global:Log.SelectionStart = $global:Log.Text.Length
    $global:Log.ScrollToCaret()
}

# Function 4.4: Master/Target Folder Selection
function Set-Path {
    param([string]$Type)
    $fb = New-Object Windows.Forms.FolderBrowserDialog
    if ($fb.ShowDialog() -eq [Windows.Forms.DialogResult]::OK) {
        if ($Type -eq "Master") {
            $global:SourcePath = $fb.SelectedPath
            Update-Log "MASTER SET: $global:SourcePath"
        } 
        else {
            $global:DestPath = $fb.SelectedPath
            Update-Log "TARGET SET: $global:DestPath"
            
            # --- THE FIX: Wake up the buttons ---
            $global:btnAudit.Enabled   = $true  
            $global:btnGenArk.Enabled    = $true
            $global:btnGenDark.Enabled   = $true
            $global:btnGenDarkRE.Enabled = $true
            $global:btnGenG350.Enabled   = $true
            $global:btnCleanup.Enabled   = $true
	    # --- THE FIX: Wake up the buttons ---
	    $global:btnAudit.Enabled   = $true  # <--- Change from btnRefresh to btnAudit
	    $global:btnAudit.BackColor = [System.Drawing.Color]::LightGreen # Optional: Make it pop!


            # Only enable Sync/Clone if BOTH Master AND Target exist
            if ($global:SourcePath -ne "") {
                $global:btnSync.Enabled  = $true
                $global:btnPowerClone.Enabled = $true
            }
        }
        $global:lblStatus.Text = "MASTER: $($global:SourcePath)`r`nTARGET: $($global:DestPath)"
    }
}

# Function 4.5: Full System Scan & Report Generation
function Run-Audit {
    param($Path, $FileName)
    if (-not (Test-Path $Path)) { return }

    # --- ONE WIDTH TO RULE THEM ALL ---
    $w = 88

    # 1. Setup the UI Log (What you see in the window)
    $global:Log.AppendText("`r`n" + ("=" * $w) + "`r`n")
    Update-Log "INITIATING AUDIT: $Path" $true
    
    # Template: {0}=ID, {1}=Name, {2}=Folder, {3}=Alias, {4}=Count, {5}=MB
    $LogTemplate = "{0,-5} | {1,-25} | {2,-15} | {3,-15} | {4,5} | {5,7}"
    $headerRow   = $LogTemplate -f "ID", "System Name", "Folder", "Alias", "ROMs", "MB"
    $global:Log.AppendText("$headerRow`r`n" + ("-" * $w) + "`r`n")

    # 2. Setup the File Storage (What goes into Target.txt)
    $fileResults = @()
    $fileResults += "--- AUDIT REPORT: $Path ---"
    $fileResults += "Generated: $(Get-Date)"
    $fileResults += $headerRow
    $fileResults += ("-" * $w)

    $folders = Get-ChildItem $Path -Directory | Sort-Object Name
    $totalSize = 0; $totalCount = 0

    foreach ($folderObj in $folders) {
        # 1. FILE COUNTING (Keep exactly as you had it)
        $roms = Get-ChildItem $folderObj.FullName -File -Recurse | Where-Object { 
            $ext = $_.Extension.ToLower()
            ($global:RomExtensions -contains $ext) -and ($ext -ne ".png" -or $_.FullName -match "pico-8")
        }
        
        $sizeMB = [math]::Round(($roms | Measure-Object -Property Length -Sum).Sum / 1MB, 2)
        $totalSize += $sizeMB; $totalCount += $roms.Count
        
        # 2. SMART DATABASE LOOKUP (Single-Match Version)
        # We find all matches, then pick the one that matches the folder depth best
        $allMatches = $global:SystemDatabase | Where-Object { 
            ($_.Folder -eq $folderObj.Name) -or ($_.Folder -split '[\\/]' -contains $folderObj.Name)
        }

        # Pick the best match: Prefer exact matches over partial subfolder matches
        $dbMatch = $allMatches | Sort-Object { $_.Folder.Length } | Select-Object -First 1

        $id    = if($dbMatch.ID) { $dbMatch.ID }    else { "???" }
        $name  = if($dbMatch.Name){ $dbMatch.Name } else { "---" }
        $alias = if($dbMatch.Alias){ $dbMatch.Alias } else { "---" }

        # 3. LOGGING (Keep exactly as you had it)
        $line = $LogTemplate -f $id, $name, $folderObj.Name, $alias, $roms.Count, $sizeMB
        $global:Log.AppendText("$line`r`n")
        $fileResults += $line
        
        [System.Windows.Forms.Application]::DoEvents()
    }

    $summary = "`r`nSUMMARY: $totalCount Files | $([math]::Round($totalSize/1024,2)) GB"
    $global:Log.AppendText($summary + "`r`n" + ("=" * $w) + "`r`n")
    $fileResults += $summary

    # --- SAVE FILE ---
    $OutputPath = Join-Path $Path $FileName
    $fileResults | Out-File $OutputPath -Force -Encoding utf8
    Update-Log "FILE SAVED: $OutputPath"
}

# Function 4.5.1: Report Generation Orchestrator, Master first, Target Second
function Invoke-FullAudit {
    Reset-ActionDisplay
    
    # 1. Audit Master FIRST (Top of Log)
    if ($global:SourcePath) {
        $global:lblAction.Text = "Auditing Master..."
        Run-Audit $global:SourcePath "Master_Audit.txt"
    }

    # 2. Audit Target LAST (Bottom of Log / Screen)
    if ($global:DestPath) {
        $global:lblAction.Text = "Auditing Target..."
        Run-Audit $global:DestPath "Target.txt"
    }
    
    $global:lblAction.Text = "Audit Complete."
}

# Function 4.6.0: Universal Folder logger
function Update-ActionLog {
    param([string]$Action, [string]$ID, [string]$Name)

    # Clean alignment for the Log Window
    $logMsg = "[{0,-7}] ({1,3}) {2}" -f $Action, $ID, $Name
    $global:Log.AppendText("$logMsg`r`n")
    
    # Auto-scroll
    $global:Log.SelectionStart = $global:Log.Text.Length
    $global:Log.ScrollToCaret()

    # DO NOT update the lblAction here anymore, 
    # let Update-UIProgress handle the fast-moving file names.
    [System.Windows.Forms.Application]::DoEvents()
}

# Function 4.6.1: OS-Specific Folder Creation (RE-Aware)
function Process-Generation {
    param([string]$OSTarget)
    if (-not (Test-PathsReady "Generation ($OSTarget)")) { return }
    
    Reset-ActionDisplay
    $global:Log.AppendText("`r`n" + ("*" * $w) + "`r`n") 
    Update-Log "GENERATING $OSTarget STRUCTURE..." $true 
    
    $count = 0
    foreach ($sys in $global:SystemDatabase) {
        # --- THE UPDATED LOGIC GATE ---
        if ($OSTarget -eq "G350Src") {
            $shouldCreate = ($sys.G350_Src -ne "---" -and (Test-Path (Join-Path $global:SourcePath $sys.G350_Src)))
        }
        elseif ($OSTarget -match "RE") {
            $shouldCreate = ($sys.dArkOS -eq $true) 
        }
        else {
            $shouldCreate = ($sys.$OSTarget -eq $true)
        }

        if ($shouldCreate) {
            $targetPath = Join-Path $global:DestPath $sys.Folder
            
            # --- THE SAFETY GATE: Check for Subfolders ---
            if ($sys.Folder -match '[\\/]') {
                $parentDir = Split-Path $targetPath -Parent
                if (!(Test-Path $parentDir) -and (Split-Path $parentDir -Leaf)) {
                    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
                }
            }

            if (!(Test-Path $targetPath)) {
                New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
                
                # --- LOGGING ---
                $displayID = if ($OSTarget -match "RE") { $sys.RE_ID } else { $sys.ID }
                Update-ActionLog -Action "CREATED" -ID $displayID -Name $sys.Name
                $count++
            }
            [System.Windows.Forms.Application]::DoEvents()
        }
    } # <--- BRACKET 1: Closes the "foreach" loop
    
    Update-Log "GEN COMPLETE: $count clean folders prepared for migration." $true
} # <--- BRACKET 2: Closes the "function"

# Function 4.7: Centralized File Transfer Logic (v1.0.0 Stable)
function Start-FileTransfer {
    param($FileList, $Title)

    # 1. Initialization - Resetting the "Relays"
    $global:btnSync.Enabled = $false
    $global:btnPowerClone.Enabled = $false
    $global:AbortSync = $false
    $global:btnAbort.Enabled = $true
    $global:ProgressBar.Value = 0
    $global:ProgressBar.Visible = $true
    $global:lblAction.Visible = $true
    $lastFolder = "" 

    Update-Log "STARTING: $Title" $true

    # 2. Data Prep - Calculating the "Load"
    $totalBytes = 0
    $processedFiles = foreach ($f in $FileList) {
        if (Test-Path $f) {
            $fInfo = New-Object System.IO.FileInfo($f)
            $totalBytes += $fInfo.Length
            [PSCustomObject]@{ Path=$f; Size=$fInfo.Length; Name=$fInfo.Name; Dir=$fInfo.DirectoryName; LastWrite=$fInfo.LastWriteTime }
        }
    }

    # 3. Transfer Loop - The "Engine Room"
    $bytesDone = 0; $count = 0; $sw = [System.Diagnostics.Stopwatch]::StartNew()
    
    foreach ($file in $processedFiles) {
        # --- THE E-STOP ---
        if ($global:AbortSync) { break }
        
        $relPath = $file.Path.Replace($global:SourcePath, "").TrimStart('\')
        $targetFile = Join-Path $global:DestPath $relPath
        $targetDir = Split-Path $targetFile
        $currentFolder = Split-Path $file.Dir -Leaf

        # --- GPS LOGGING (System Level) ---
        if ($currentFolder -ne $lastFolder) {
            $dbMatch = $global:SystemDatabase | Where-Object { $_.Folder -eq $currentFolder }
            $id   = if($dbMatch.ID){ $dbMatch.ID } else { "---" }
            $name = if($dbMatch.Name){ $dbMatch.Name } else { $currentFolder }
            
            Update-ActionLog -Action "COPYING" -ID $id -Name $name
            $lastFolder = $currentFolder
        }

        # --- EXECUTION (File Level) ---
        # Only copy if file is missing or newer
        if (!(Test-Path $targetFile) -or ($file.LastWrite -gt (Get-Item $targetFile).LastWriteTime)) {
            if (!(Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }
            
            # Using /MT:8 for stability on SD cards
            robocopy $file.Dir $targetDir $file.Name /Z /MT:8 /R:1 /W:1 /NP /NFL /NDL /NJH /NJS | Out-Null
            $count++
        }

        # --- DASHBOARD UPDATE ---
        $bytesDone += $file.Size
        Update-UIProgress -BytesDone $bytesDone -TotalBytes $totalBytes -Stopwatch $sw -FileName $file.Name
        
        # --- UI HEARTBEAT ---
        [System.Windows.Forms.Application]::DoEvents() 
    }

    # 4. Finalize - Powering Down the Relays
    $global:btnAbort.Enabled = $false
    $global:ProgressBar.Visible = $false
    $global:btnSync.Enabled = $true
    $global:btnPowerClone.Enabled = $true 

    if ($global:AbortSync) {
        Update-Log "!!! OPERATION HALTED BY USER !!!" $true
        $global:lblAction.Text = "ABORTED: Process Stopped."
        $global:lblAction.ForeColor = [System.Drawing.Color]::Red
    } 
    else {
        Update-Log "SUCCESS: $count files processed." $true
        $global:lblAction.Text = "Operation Complete."
        Run-Audit $global:DestPath "Target_Audit.txt"
    }
}

# Function 4.8: Smart Sync & Brute Clone Handlers (v1.0.0 Stable)
function Invoke-UniversalSync {
    if (-not (Test-PathsReady "Universal Sync")) { return }

    # --- RESET THE RELAYS ---
    $global:AbortSync = $false
    $global:lblAction.ForeColor = [System.Drawing.Color]::Black
    $global:btnAbort.Enabled = $true
    
    # Disable the Clone button so they don't fight!
    $global:btnPowerClone.Enabled = $false 

    # 1. Update Log with Header
    $global:Log.AppendText("`r`n" + ("-" * 60) + "`r`n")
    Update-Log "Scanning for ROMs (Filtered Sync)..." $true

    # 2. Discovery with Filter
    $allFiles = [System.IO.Directory]::GetFiles($global:SourcePath, "*.*", [System.IO.SearchOption]::AllDirectories) | Where-Object { 
        $ext = [System.IO.Path]::GetExtension($_).ToLower()
        ($global:RomExtensions -contains $ext) -and ($ext -ne ".png" -or $_ -match "pico-8") 
    }

    if ($allFiles.Count -eq 0) {
        Update-Log "No matching ROMs found in Master folder." $true
        $global:btnPowerClone.Enabled = $true # Re-enable on fail
        return
    }

    # 3. Hand-off to Master Engine
    Start-FileTransfer -FileList $allFiles -Title "UNIVERSAL SYNC"
}

function Invoke-PowerClone {
    if (-not (Test-PathsReady "Power Clone")) { return }
    Reset-ActionDisplay

    # --- CHOICE A: FOLDERS ONLY ---
    if ($global:rbFoldersOnly.Checked) {
        $global:Log.AppendText("`r`n" + ("=" * 60) + "`r`n")
        Update-Log "CLONING DIRECTORY STRUCTURE ONLY..." $true
        
        robocopy $global:SourcePath $global:DestPath /E /XF * /R:1 /W:1 /NJH /NJS /NFL /NDL | Out-Null
        
        $folderCount = (Get-ChildItem $global:DestPath -Directory).Count
        Update-Log "CLONE COMPLETE: $folderCount System Folders verified/created." $true
        $global:ProgressBar.Value = 100
        $global:ProgressBar.Visible = $false
        
        Run-Audit $global:DestPath "Target_Audit.txt"
        return # Closes this Rung safely
    }

    # --- CHOICE C: SYSTEM FOLDERS ONLY ---
    elseif ($global:rbSystemOnly.Checked) {
        $global:Log.AppendText("`r`n" + ("=" * 60) + "`r`n")
        Update-Log "CLONING SYSTEM FOLDERS (BIOS, Ports, Tools)..." $true
        
        $systemFolders = @("bios", "ports", "tools")
        $systemFiles = @()

        foreach ($folder in $systemFolders) {
            $path = Join-Path $global:SourcePath $folder
            if (Test-Path $path) {
                $systemFiles += [System.IO.Directory]::GetFiles($path, "*.*", [System.IO.SearchOption]::AllDirectories)
            }
        }

        if ($systemFiles.Count -gt 0) {
            Start-FileTransfer -FileList $systemFiles -Title "SYSTEM FOLDER CLONE"
            return # <--- MUST be inside the bracket
        }
        else {
            Update-Log "No system files found in Master BIOS/Ports/Tools folders." $true
        }
    } 

    # --- CHOICE B: EVERYTHING (Brute Force) ---
    else {
        $global:Log.AppendText("`r`n" + ("=" * 60) + "`r`n")
        Update-Log "SCANNING ALL FILES (Full System Mirror)..." $true
        
        $allFiles = [System.IO.Directory]::GetFiles($global:SourcePath, "*.*", [System.IO.SearchOption]::AllDirectories)
        
        if ($allFiles.Count -gt 0) {
            Start-FileTransfer -FileList $allFiles -Title "POWER CLONE (FULL)"
            return # <--- MUST be inside the bracket
        }
        else {
            Update-Log "Master folder is empty! Nothing to clone." $true
        }
    }
}

# Function 4.9: Advanced Mirror/Cleanup Logic
function Invoke-Cleanup {
    if (-not (Test-PathsReady "Cleanup (Mirror Mode)")) { return }

    # 1. Safety Confirmation
    $msg = "MIRROR MODE: This will PERMANENTLY DELETE files and FOLDERS on the TARGET (SD) that do not exist on the MASTER (PC).`n`nProceed?"
    if ([System.Windows.Forms.MessageBox]::Show($msg, "Critical Warning", [System.Windows.Forms.MessageBoxButtons]::YesNo, 
	[System.Windows.Forms.MessageBoxIcon]::Warning) -ne [System.Windows.Forms.DialogResult]::Yes) { return }
  
    # --- Add this to the top of your functions in Section 4 ---
    $global:AbortSync = $false              # Reset the abort trigger
    $global:lblAction.ForeColor = [System.Drawing.Color]::Black # Reset text color
    # 2. Reset UI for Action
    $global:btnAbort.Enabled = $true
    $global:Log.AppendText("`r`n" + ("!" * $w) + "`r`n") 
    Update-Log "STARTING CLEANUP (MIRROR MODE)..." $true

    # --- NEW STEP: THE GHOST PURGE ---
    # Find folders on Target that aren't on Master
    $masterFolderNames = Get-ChildItem $global:SourcePath -Directory | Select-Object -ExpandProperty Name
    $targetFolders = Get-ChildItem $global:DestPath -Directory
    
    foreach ($tFolder in $targetFolders) {
        if ($masterFolderNames -notcontains $tFolder.Name) {
            Update-Log "PURGING GHOST FOLDER: $($tFolder.Name)"
            Remove-Item $tFolder.FullName -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    # 3. Execution (Folder by Folder Mirroring)
    $masterDirs = Get-ChildItem $global:SourcePath -Directory
    $total = $masterDirs.Count; $current = 0

foreach ($dir in $masterDirs) {
    # Check for Abort BEFORE starting the next folder
    if ($global:AbortSync) { 
        Update-Log "CLEANUP HALTED BY USER." $true
        break 
    }
    
    $targetPath = Join-Path $global:DestPath $dir.Name
    if (Test-Path $targetPath) {
        Update-Log "Mirroring: $($dir.Name)..."
        
        # We run Robocopy. If Abort is clicked, the Stop-Process above kills it.
        robocopy $dir.FullName $targetPath /MIR /R:1 /W:1 /NP /NFL /NDL /NJH /NJS /MT:8 | Out-Null
    }

    # This line is CRITICAL - it allows the UI to "hear" the Abort button click
    [System.Windows.Forms.Application]::DoEvents()

    # Progress Update...
    $current++
    # ... rest of your progress bar code ...

        $percent = [int](($current / $total) * 100)
        $global:ProgressBar.Value = $percent
        $global:ProgressBar.Visible = $true
        [System.Windows.Forms.Application]::DoEvents()
    }

    # 4. Finalize
    $global:ProgressBar.Visible = $false
    $global:btnAbort.Enabled = $false

    if ($global:AbortSync) {
        # --- THE ABORT MESSAGE ---
        Update-Log "!!! CLEANUP ABORTED BY USER !!!" $true
        $global:lblAction.Text = "ABORTED: Process Halted."
        $global:lblAction.ForeColor = [System.Drawing.Color]::Red
    } 
    else {
        # --- THE SUCCESS MESSAGE ---
        Update-Log "CLEANUP FINISHED. Target is now a perfect 1:1 mirror." $true
        $global:lblAction.Text = "Clean Complete."
        $global:lblAction.ForeColor = [System.Drawing.Color]::Black # Reset to normal
        
        # Only refresh the Audit if it actually finished
        Run-Audit $global:DestPath "Target_Audit.txt"
    }

    $global:Log.AppendText(("!" * $w) + "`r`n")
}

# --- Function 4.10: G350 to ArkOS Smart Migration ---
function Invoke-G350Src {
    if (-not (Test-PathsReady "G350 Migration")) { return }
    Reset-ActionDisplay
    
    Update-Log "G350 SMART MIGRATION: Building File List..." $true
    
    # 1. Build the "Smart List" (Only things in our 130-system DB)
    $migrationList = @()
    foreach ($sys in $global:SystemDatabase) {
        # Check G350_Src first, fallback to Folder
        $srcName = if ($sys.G350_Src -ne "---") { $sys.G350_Src } else { $sys.Folder }
        $srcFull = Join-Path $global:SourcePath $srcName
        
        if (Test-Path $srcFull) {
            # Get all ROM files in this specific G350 folder
            $files = Get-ChildItem $srcFull -File -Recurse
            $migrationList += $files.FullName
        }
    }

    # 2. Hand off the list to your Universal Sync engine
    if ($migrationList.Count -gt 0) {
        # This calls your working, safe, abortable transfer logic
        Start-FileTransfer -FileList $migrationList -Title "G350 TO ARKOS MIGRATION"
    } else {
        [System.Windows.Forms.MessageBox]::Show("No matching G350 folders found in Master path.")
    }
}

# Function 4.11: Total UI & Variable Reset
function Reset-ActionDisplay {
    # 1. Reset the "Kill Switch"
    $global:AbortSync = $false
    
    # 2. Reset the Status Ribbon
    $global:lblAction.ForeColor = [System.Drawing.Color]::Black
    $global:lblAction.Text      = "Ready..."
    
    # 3. Clean the Progress Bar
    $global:ProgressBar.Value   = 0
    $global:ProgressBar.Visible = $false
    
    # 4. Process pending UI updates
    [System.Windows.Forms.Application]::DoEvents()
}

function Reset-AllSelections {
    $global:SourcePath = ""
    $global:DestPath = ""
    $global:lblStatus.Text = "Ready"
    $global:lblAction.Text = "All selections cleared."
    $global:lblAction.Visible = $false
    $global:Log.Clear()
    $global:ProgressBar.Value = 0
    $global:ProgressBar.Visible = $false
    
    # Disable Action Buttons
    $global:btnSync.Enabled       = $false
    $global:btnPowerClone.Enabled      = $false
    $global:btnCleanup.Enabled    = $false
    $global:btnGenArk.Enabled     = $false
    $global:btnGenDark.Enabled    = $false
    $global:btnGenDarkRE.Enabled  = $false
    $global:btnGenG350.Enabled    = $false
    
    Update-Log "SYSTEM RESET COMPLETE."
}

# Function 4.12: Emergency Stop
function Invoke-Abort {
    $global:AbortSync = $true
    Update-Log "!!! STOP SIGNAL SENT: ABORTING CURRENT TASK !!!" $true
}

# Function 4.13: Help
function Show-HelpManual {
    $global:Log.Clear()

    # In your Startup or Help function:
    $global:Log.AppendText($HeaderArt + "`r`n")

    # 2. Add 3 blank lines for "Breathing Room"
    $global:Log.AppendText("`r`n`r`n") 

    $hr = "=" * 100
    $global:Log.AppendText("$hr`r`n")   
    $global:Log.AppendText(" R36S FILE MANAGER - QUICK REFERENCE GUIDE`r`n")
    $global:Log.AppendText("$hr`r`n`r`n")

    
    $global:Log.AppendText("      ***** First select a MASTER and a TARGET folder to activate the functional buttons. *****`r`n`r`n" )

    $HelpItems = @(	
        @{ Cmd = "[ Sel MASTER ]"; Desc = "Sets the path to your Master PC 'Gold Standard' ROM collection folder." },
        @{ Cmd = "[ Sel TARGET ]"; Desc = "Sets the path to your Target SD Card or handheld device folder." },
        @{ Cmd = "[ UNIV SYNC ]" ; Desc = "SAFE. Copies only the missing files from Master to Target." },
        @{ Cmd = "[ PWR CLONE a]"; Desc = "BRUTE FORCE. Makes Target an EXACT mirror of Master, Folders Only or EVERYTHING." },
        @{ Cmd = "[ PWR CLONE b]"; Desc = "System Only option clones BIOS, Ports, and Tools folders only" },
        @{ Cmd = "[ SYS AUDIT ]" ; Desc = "Scans then generates the pipe-separated report and .txt file for review/import." },
        @{ Cmd = "[ CLEAN Mir ]" ; Desc = "Removes ._ files, empty folders, and junk, making the Target match the Master. " },
        @{ Cmd = "[ ABORT ]"     ; Desc = "Sends the ABORT command and HALTS the current operation from completing." },
        @{ Cmd = "[ GEN xxxOS ]" ; Desc = "Creates the specific folder structure for ArkOS / dArkOS / RE." },
        @{ Cmd = "[ G350 Src a]" ; Desc = "Uses a stock G350 SD (Set to MASTER), as a source to append a clean ArkOS structure." },
        @{ Cmd = "[ G350 Src b]" ; Desc = "If you run this first, it only creates the folders containing ROMS on your target." }  
				
	   
    )

    foreach ($item in $HelpItems) {
        $row = "{0,-15} : {1}" -f $item.Cmd, $item.Desc
        $global:Log.AppendText("$row`r`n")
    }
    
    	   $global:Log.AppendText("`r`n$hr`r`n")
    	   # $global:Log.AppendText(" TIP: Hover over the [?] icons for specific system help.`r`n")
	   $global:Log.AppendText("This tool is still BETA and under development.  Use with CAUTION, at your own risk.`r`n")
    	   $global:Log.AppendText("$hr`r`n`r`n")
}

# ==============================================================================
# SECTION 5: THE NERVOUS SYSTEM (Event Handlers)
# ==============================================================================

# --- 5.1: PATH SELECTION EVENTS ---
# Links the PC and SD folder pickers
$global:btnMaster.Add_Click({ Reset-ActionDisplay; Set-Path "Master" })
$global:btnSD.Add_Click({     Reset-ActionDisplay; Set-Path "Target" })

# --- 5.2: CORE ACTION EVENTS ---
# Links Sync, Clone, and Cleanup logic
$global:btnSync.Add_Click({    Reset-ActionDisplay; Invoke-UniversalSync })
$global:btnPowerClone.Add_Click({   Reset-ActionDisplay; Invoke-PowerClone })
$global:btnCleanup.Add_Click({ Reset-ActionDisplay; Invoke-Cleanup })

# --- 5.3: GENERATION & FIX EVENTS ---
# Links the Green/Yellow OS buttons
$global:btnGenArk.Add_Click({    Reset-ActionDisplay; Process-Generation "ArkOS" })
$global:btnGenDark.Add_Click({   Reset-ActionDisplay; Process-Generation "dArkOS" })
$global:btnGenDarkRE.Add_Click({ Reset-ActionDisplay; Process-Generation "dArkOSRE" })
$global:btnGenG350.Add_Click({ Reset-ActionDisplay; Process-Generation "G350Src" })

# --- 5.4: UTILITY & SAFETY EVENTS ---
# Audit now handles the file generation logic
# Update this line to match your new name!

# Ref: Function 4.5.1: function Invoke-FullAudit
$global:btnAudit.Add_Click({ Invoke-FullAudit })

$global:btnAbort.Add_Click({
    $global:AbortSync = $true
    $global:lblAction.Text = "ABORTING... PLEASE WAIT"
    $global:lblAction.ForeColor = [System.Drawing.Color]::Red

    # This "kills" the actual Robocopy engine immediately
    Stop-Process -Name "robocopy" -Force -ErrorAction SilentlyContinue
    
    Update-Log "!!! ABORT COMMAND ISSUED !!!" $true
})

# This is now your "Master Reset"
$global:btnReset.Add_Click({   
    Reset-AllSelections  # Clears the folder paths
    $Log.Clear()         # Wipes the text window
    $global:lblAction.Text = "System Reset. Ready for new selection."
    
    # Optional: Put the Audit button back to sleep until a new path is picked
    $global:btnAudit.Enabled = $false
    $global:btnAudit.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#e0e0e0")
})


# --- 5.4: GITHUB DYNAMIC LINK (Final Commissioning) ---
$global:lblGitHub.add_LinkClicked({ 
    # 1. Grab "vx.x.x" (or whatever the file is named)
    $currentVersion = (Get-Item $PSCommandPath).BaseName 
    
    # 2. Point it to your REAL repository
    # This link will take them directly to the "Releases" page for that version
    $url = "https://github.com/jj1eckhardt-beep/R36S-File-Manager/tree/main"
    
    # 3. Fallback: If you haven't made a "Release" yet, just point to the main page
    # $url = "https://github.com"
    
    Start-Process $url 
})


# --- 5.5: THE NEW HELP SYSTEM ---
# 1. Clicking the [?] in the header now prints the Manual to the Log Window
$global:lblHelpHint.add_LinkClicked({ Show-HelpManual })

# 2. (Optional) If you want a button to trigger the manual too:
# $global:btnHelp.Add_Click({ Show-HelpManual })


# ==============================================================================
# SECTION 6: THE ASSEMBLY & LAUNCH
# ==============================================================================

# --- 6.1: FORM CONTROL AGGREGATION ---
# This physically adds every button, label, and box to the window.
# Order here doesn't affect logic, but it affects "Tab" order for keyboards.
$global:Form.Controls.AddRange(@(
    $global:lblHelpHint
    $global:btnMaster, 
    $global:btnSD, 
    $global:lblStatus, 
    $global:btnReset,
    $global:btnSync, 
    $global:btnAbort, 
    $global:btnCleanup,
    $global:btnGenArk, 
    $global:btnGenDark, 
    $global:btnGenDarkRE, 
    $global:btnGenG350,
    $global:btnPowerClone,
    $global:gbCloneMode, 
    $global:btnAudit,
    $global:lblAction, 
    $global:ProgressBar, 
    $global:Log, 
    $global:lblGitHub
))

# --- 6.2: FINAL UI TWEAKS ---
# Ensures the Log window starts at the top and the focus is neutral
Reset-AllSelections # <--- Forces a clean start every time!
$global:Log.SelectionStart = 0
$global:Log.SelectionStart = 0
$global:Log.DeselectAll()

# --- 6.3: THE FINAL LAUNCHER ---
# This is the very last line of the script. It opens the window and 
# keeps the script running until you close the X.
$global:Form.ShowDialog()

# --- END OF SCRIPT ---
# Cleaning up memory after the form closes (optional but good practice)
$global:Form.Dispose()



