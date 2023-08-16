class_name VolumeSlider
extends HSlider

# ------------------------------------------------------------------------------
# @export variables ------------------------------------------------------------

@export var audio_bus_name: String


# ------------------------------------------------------------------------------
# @onready variables -----------------------------------------------------------

@onready var audio_bus_index: int


# ------------------------------------------------------------------------------
# built-in virtual methods -----------------------------------------------------
 
# called when both the node and its children have entered the scene tree
func _ready() -> void:
    audio_bus_index = AudioServer.get_bus_index(audio_bus_name)
    value = db_to_linear(AudioServer.get_bus_volume_db(audio_bus_index))