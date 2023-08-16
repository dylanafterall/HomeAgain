class_name AudioSettings
extends CanvasLayer

# ------------------------------------------------------------------------------
# @export variables ------------------------------------------------------------

@export_group("SceneSwitcher Settings")
@export_file var back_scene
@export_group("")


# ------------------------------------------------------------------------------
# @onready variables -----------------------------------------------------------

@onready var mute_button: Button = %MuteButton
@onready var master_slider: HSlider = %MasterSlider
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var speech_slider: HSlider = %SpeechSlider
@onready var ambience_slider: HSlider = %AmbienceSlider
@onready var reset_button: Button = %ResetButton
@onready var back_button: Button = %BackButton

@onready var _labels: Dictionary = {
    mute_button:%MuteLabel,
    master_slider:%MasterLabel,
    music_slider:%MusicLabel,
    sfx_slider:%SFXLabel,
    speech_slider:%SpeechLabel,
    ambience_slider:%AmbienceLabel,
}


# ------------------------------------------------------------------------------
# built-in virtual methods -----------------------------------------------------

# called when both the node and its children have entered the scene tree
func _ready() -> void:
    # connect signals
    var check_buttons = get_tree().get_nodes_in_group("CheckButtons")
    for check_button in check_buttons:
        check_button.mouse_entered.connect(check_button.grab_focus)
        check_button.focus_entered.connect(_move_to_object.bind(check_button))
        check_button.focus_exited.connect(_move_from_object.bind(check_button))
        check_button.toggled.connect(_checkbutton_action.bind(check_button))
        
    var sliders = get_tree().get_nodes_in_group("Sliders")
    for slider in sliders:
        slider.mouse_entered.connect(slider.grab_focus)
        slider.focus_entered.connect(_move_to_object.bind(slider))
        slider.focus_exited.connect(_move_from_object.bind(slider))
        slider.value_changed.connect(_slider_action.bind(slider))   
        
    var buttons = get_tree().get_nodes_in_group("Buttons")
    for button in buttons:
        button.mouse_entered.connect(button.grab_focus)
        button.focus_entered.connect(_move_to_button.bind(button))
        button.focus_exited.connect(_move_from_button.bind(button))
        button.pressed.connect(_button_action.bind(button))
        
    # setup button data
    reset_defaults()
    mute_button.grab_focus()


# ------------------------------------------------------------------------------
# private methods --------------------------------------------------------------

func _move_to_object(object) -> void:
    var label: Label = _labels[object]
    label.add_theme_color_override("font_color", label.get_theme_color("nasa_white_color"))
    label.get_child(0).visible = true	
    label.get_child(1).visible = true	
    
    if object is CheckButton:
        object.add_theme_icon_override("checked", object.get_theme_icon("checked_nasa"))
        object.add_theme_icon_override("unchecked", object.get_theme_icon("unchecked_nasa"))


func _move_from_object(object) -> void: 
    var label: Label = _labels[object]
    label.remove_theme_color_override("font_color")
    label.get_child(0).visible = false	
    label.get_child(1).visible = false
    
    if object is CheckButton:
        object.remove_theme_icon_override("checked")
        object.remove_theme_icon_override("unchecked")
    
    
func _checkbutton_action(pressed: bool, button: CheckButton) -> void:
    if pressed:
        match button:
            mute_button:
                for slider in get_tree().get_nodes_in_group("Sliders"):
                    AudioServer.set_bus_mute(AudioServer.get_bus_index(slider.audio_bus_name), true)
                    slider.editable = false
                    slider.add_theme_stylebox_override("grabber_area", slider.get_theme_stylebox("muted_grabber_area"))
                    slider.add_theme_stylebox_override("slider", slider.get_theme_stylebox("muted_slider"))
    else:
        match button:
            mute_button:
                for slider in get_tree().get_nodes_in_group("Sliders"):
                    AudioServer.set_bus_mute(AudioServer.get_bus_index(slider.audio_bus_name), false)
                    slider.editable = true
                    slider.remove_theme_stylebox_override("grabber_area")
                    slider.remove_theme_stylebox_override("slider")
    
    
func _slider_action(value: float, slider: HSlider) -> void:
    AudioServer.set_bus_volume_db(AudioServer.get_bus_index(slider.audio_bus_name), linear_to_db(value))
    

func _move_to_button(button: Button) -> void:
    var tween = create_tween()
    tween.stop()
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(
        button,
        "scale",
        Vector2.ONE * 1.1,
        0.2
    )
    tween.play()


func _move_from_button(button: Button) -> void:	
    var tween = create_tween()
    tween.stop()
    tween.set_trans(Tween.TRANS_CUBIC)
    tween.set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(
        button,
        "scale",
        Vector2.ONE,
        0.2
    )
    tween.play()


func _button_action(object) -> void:
    match object:
        reset_button:
            reset_defaults()
        back_button:
            SceneSwitcher.GoToScene(back_scene)


func reset_defaults() -> void:
    mute_button.button_pressed = false
    
    var master_index = AudioServer.get_bus_index(master_slider.audio_bus_name)
    AudioServer.set_bus_volume_db(master_index, -7.5)
    master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_index))
    
    var music_index = AudioServer.get_bus_index(music_slider.audio_bus_name)
    AudioServer.set_bus_volume_db(music_index, 0.0)
    music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_index))
    
    var sfx_index = AudioServer.get_bus_index(sfx_slider.audio_bus_name)
    AudioServer.set_bus_volume_db(sfx_index, 0.0)
    sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_index))
    
    var speech_index = AudioServer.get_bus_index(speech_slider.audio_bus_name)
    AudioServer.set_bus_volume_db(speech_index, 0.0)
    speech_slider.value = db_to_linear(AudioServer.get_bus_volume_db(speech_index))
    
    var ambience_index = AudioServer.get_bus_index(ambience_slider.audio_bus_name)
    AudioServer.set_bus_volume_db(ambience_index, 0.0)
    ambience_slider.value = db_to_linear(AudioServer.get_bus_volume_db(ambience_index))
