class_name DefaultSettings
extends Node

# ------------------------------------------------------------------------------
# public variables -------------------------------------------------------------

const NASA_RED: Color = Color(0.99, 0.24, 0.13)      # 252,  61,  33
const NASA_BLUE: Color = Color(0.04, 0.24, 0.57)     #  11,  61, 145
const NASA_GRAY: Color = Color(0.47, 0.47, 0.49)     # 121, 121, 124
const NASA_WHITE: Color = Color(1.0, 1.0, 1.0)       # 255, 255, 255
const NASA_BLACK: Color = Color(0.0, 0.0, 0.0)       #   0,   0,   0

const MUTE: bool = false
const MASTER_VOLUME: float = -7.5
const MUSIC_VOLUME: float = 0.0
const SFX_VOLUME: float = 0.0
const SPEECH_VOLUME: float = 0.0
const AMBIENCE_VOLUME: float = 0.0

var RESOLUTION: Vector2 = DisplayServer.screen_get_size()
const RESOLUTION_INDEX: int = 4
var RESOLUTION_OPTIONS: Dictionary = {
	"1280 x 720":Vector2(1280, 720),
	"1920 x 1080":Vector2(1920, 1080),
	"2560 x 1440":Vector2(2560, 1440),
	"3840 x 2160":Vector2(3840, 2160),
	"Native Resolution":DisplayServer.screen_get_size(),
}

const MAX_FPS: int = 60
const MAX_FPS_INDEX: int = 1
const MAXFPS_OPTIONS: Dictionary = {
	"30":30,
	"60":60,
	"120":120,
	"240":240,
	"No Limit":0,
}

const ANTI_ALIAS: Viewport.MSAA = Viewport.MSAA_4X
const ANTI_ALIAS_INDEX: int = 2
const AA_OPTIONS: Dictionary = {
	"Disabled (Fastest)":Viewport.MSAA_DISABLED,
	"2x (Average)":Viewport.MSAA_2X,
	"4x (Slow)":Viewport.MSAA_4X,
	"8x (Slowest)":Viewport.MSAA_8X,
}

const FULLSCREEN: bool = false
const VSYNC: bool = true
const SHOW_FPS: bool = true
const BRIGHTNESS: float = 1.0
const CONTRAST: float = 1.0
const SATURATION: float = 1.0