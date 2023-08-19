class_name VideoSettings
extends CanvasLayer

# ------------------------------------------------------------------------------
# signals ----------------------------------------------------------------------

signal back_from_video


# ------------------------------------------------------------------------------
# private variables ------------------------------------------------------------

const SAVE_FILE: String = "user://user_video_settings.cfg"


# ------------------------------------------------------------------------------
# @onready variables -----------------------------------------------------------

@onready var defaults = %Defaults
@onready var display_button = %DisplayButton
@onready var resolution_button = %ResolutionButton
@onready var vsync_button = %VSyncButton
@onready var max_fps_button = %MaxFPSButton
@onready var show_fps_button = %ShowFPSButton
@onready var aa_button = %AAButton
@onready var brightness_slider = %BrightnessSlider
@onready var contrast_slider = %ContrastSlider
@onready var saturation_slider = %SaturationSlider
@onready var reset_button = %ResetButton
@onready var back_button = %BackButton

@onready var _labels: Dictionary = {
    display_button:%DisplayLabel,
    resolution_button:%ResolutionLabel,
    vsync_button:%VSyncLabel,
    max_fps_button:%MaxFPSLabel,
    show_fps_button:%ShowFPSLabel,
    aa_button:%AALabel,
    brightness_slider:%BrightnessLabel,
    contrast_slider:%ContrastLabel,
    saturation_slider:%SaturationLabel,
}


# ------------------------------------------------------------------------------
# built-in virtual methods -----------------------------------------------------

# called when both the node and its children have entered the scene tree
func _ready() -> void:
    # connect signals	
    var option_buttons = get_tree().get_nodes_in_group("VideoOptionButtons")
    for option_button in option_buttons:
        option_button.mouse_entered.connect(option_button.grab_focus)
        option_button.focus_entered.connect(_move_to_object.bind(option_button))
        option_button.focus_exited.connect(_move_from_object.bind(option_button))
        option_button.item_selected.connect(_optionbutton_action.bind(option_button))
        
    var check_buttons = get_tree().get_nodes_in_group("VideoCheckButtons")
    for check_button in check_buttons:
        check_button.mouse_entered.connect(check_button.grab_focus)
        check_button.focus_entered.connect(_move_to_object.bind(check_button))
        check_button.focus_exited.connect(_move_from_object.bind(check_button))
        check_button.toggled.connect(_checkbutton_action.bind(check_button))
        
    var sliders = get_tree().get_nodes_in_group("VideoSliders")
    for slider in sliders:
        slider.mouse_entered.connect(slider.grab_focus)
        slider.focus_entered.connect(_move_to_object.bind(slider))
        slider.focus_exited.connect(_move_from_object.bind(slider))
        slider.value_changed.connect(_slider_action.bind(slider))   
        
    var buttons = get_tree().get_nodes_in_group("VideoButtons")
    for button in buttons:
        button.mouse_entered.connect(button.grab_focus)
        button.focus_entered.connect(_move_to_button.bind(button))
        button.focus_exited.connect(_move_from_button.bind(button))
        button.pressed.connect(_button_action.bind(button))
        
    add_resolutions()
    add_aa_options()
    add_maxfps_options()
    
    if FileAccess.file_exists(SAVE_FILE):
        read_from_save()
    else:
        reset_defaults()
    
    display_button.grab_focus()


# ------------------------------------------------------------------------------
# private methods --------------------------------------------------------------

func add_resolutions() -> void:
    for resolution in defaults.RESOLUTION_OPTIONS:
        resolution_button.add_item(resolution)
    

func add_aa_options() -> void:
    for aa_option in defaults.AA_OPTIONS:
        aa_button.add_item(aa_option)
        
        
func add_maxfps_options() -> void:
    for maxfps_option in defaults.MAXFPS_OPTIONS:
        max_fps_button.add_item(maxfps_option)
        
        
func _move_to_object(object) -> void:
    var label: Label = _labels[object]
    label.add_theme_color_override("font_color", defaults.NASA_WHITE)
    label.get_child(0).visible = true	
    label.get_child(1).visible = true	
    
    if object is CheckButton:
        object.add_theme_icon_override("checked", object.get_theme_icon("checked_nasa"))
        object.add_theme_icon_override("unchecked", object.get_theme_icon("unchecked_nasa"))
        
    if object is OptionButton:
        if object.disabled == true:
            object.add_theme_stylebox_override("focus", object.get_theme_stylebox("disabled"))
        else:
            object.add_theme_color_override("font_outline_color", defaults.NASA_RED)
        
    
func _move_from_object(object) -> void:    
    var label: Label = _labels[object]
    label.remove_theme_color_override("font_color")
    label.get_child(0).visible = false	
    label.get_child(1).visible = false
    
    if object is CheckButton:
        object.remove_theme_icon_override("checked")
        object.remove_theme_icon_override("unchecked")
        
    if object is OptionButton:
        if object.disabled == true:
            object.remove_theme_stylebox_override("focus")
        else:
            object.remove_theme_color_override("font_outline_color")
        
        
func _optionbutton_action(index: int, button: OptionButton) -> void:	
    match button:
        resolution_button:
            var new_size: Vector2 = defaults.RESOLUTION_OPTIONS.get(resolution_button.get_item_text(index))
            get_viewport().set_size(new_size)
        aa_button:
            var new_aa = defaults.AA_OPTIONS.get(aa_button.get_item_text(index))
            get_viewport().msaa_2d = new_aa
        max_fps_button:
            var new_maxfps = defaults.MAXFPS_OPTIONS.get(max_fps_button.get_item_text(index))
            Engine.set_max_fps(new_maxfps)
            

func _checkbutton_action(pressed: bool, button: CheckButton) -> void:
    if pressed:
        match button:
            display_button:
                resolution_button.select(defaults.RESOLUTION_OPTIONS.size() - 1)   # native res
                resolution_button.disabled = true
                DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
            vsync_button:
                max_fps_button.disabled = true
                DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
            show_fps_button:
                SystemInfoDisplay.ShowFPS()
    else:
        match button:
            display_button:
                DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
                resolution_button.disabled = false
            vsync_button:
                DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
                max_fps_button.disabled = false
                var new_maxfps = defaults.MAXFPS_OPTIONS[max_fps_button.get_item_text(max_fps_button.get_selected())]
                Engine.set_max_fps(new_maxfps)
            show_fps_button:
                SystemInfoDisplay.HideFPS()
                
                
func _slider_action(value: float, slider: HSlider) -> void:
    match slider:
        brightness_slider:
            WorldEnv.get_environment().set_adjustment_brightness(value)
        contrast_slider:
            WorldEnv.get_environment().set_adjustment_contrast(value)
        saturation_slider:
            WorldEnv.get_environment().set_adjustment_saturation(value)
    
    
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
       
            
func reset_defaults() -> void:
    display_button.button_pressed = defaults.FULLSCREEN
    resolution_button.select(defaults.RESOLUTION_INDEX)
    get_viewport().set_size(defaults.RESOLUTION)
    vsync_button.button_pressed = defaults.VSYNC
    max_fps_button.select(defaults.MAX_FPS_INDEX)
    Engine.set_max_fps(defaults.MAX_FPS)
    show_fps_button.button_pressed = defaults.SHOW_FPS
    aa_button.select(defaults.ANTI_ALIAS_INDEX)
    get_viewport().msaa_2d = defaults.ANTI_ALIAS
    brightness_slider.set_value(defaults.BRIGHTNESS)
    contrast_slider.set_value(defaults.CONTRAST)
    saturation_slider.set_value(defaults.SATURATION)
    
    
func write_to_save() -> void:
    var config = ConfigFile.new()
    
    config.set_value("Video", "user_display_button_pressed", display_button.is_pressed())
    config.set_value("Video", "user_resolution_index", resolution_button.get_selected())
    config.set_value("Video", "user_resolution", resolution_button.get_item_text(resolution_button.get_selected()))
    config.set_value("Video", "user_vsync_button_pressed", vsync_button.is_pressed())
    config.set_value("Video", "user_max_fps_index", max_fps_button.get_selected())
    config.set_value("Video", "user_max_fps", max_fps_button.get_item_text(max_fps_button.get_selected()))
    config.set_value("Video", "user_show_fps_pressed", show_fps_button.is_pressed())
    config.set_value("Video", "user_aa_index", aa_button.get_selected())
    config.set_value("Video", "user_aa", aa_button.get_item_text(aa_button.get_selected()))
    config.set_value("Video", "user_brightness", brightness_slider.get_value())
    config.set_value("Video", "user_contrast", contrast_slider.get_value())
    config.set_value("Video", "user_saturation", saturation_slider.get_value())
    
    config.save(SAVE_FILE)


func read_from_save() -> void:
    var config = ConfigFile.new()
    
    var err = config.load(SAVE_FILE)
    if err != OK:
        return
        
    display_button.button_pressed = config.get_value("Video", "user_display_button_pressed")
    resolution_button.select(config.get_value("Video", "user_resolution_index"))
    get_viewport().set_size(defaults.RESOLUTION_OPTIONS[config.get_value("Video", "user_resolution")])
    vsync_button.button_pressed = config.get_value("Video", "user_vsync_button_pressed")
    if !config.get_value("Video", "user_vsync_button_pressed"):
        DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
    max_fps_button.select(config.get_value("Video", "user_max_fps_index"))
    Engine.set_max_fps(defaults.MAXFPS_OPTIONS[config.get_value("Video", "user_max_fps")])
    show_fps_button.button_pressed = config.get_value("Video", "user_show_fps_pressed")
    aa_button.select(config.get_value("Video", "user_aa_index"))
    get_viewport().msaa_2d = defaults.AA_OPTIONS[config.get_value("Video", "user_aa")]
    brightness_slider.set_value(config.get_value("Video", "user_brightness"))
    contrast_slider.set_value(config.get_value("Video", "user_contrast"))
    saturation_slider.set_value(config.get_value("Video", "user_saturation"))
        
        
func _button_action(object) -> void:	
    match object:
        reset_button:
            reset_defaults()
        back_button:
            SystemInfoDisplay.UpdateSettings()
            write_to_save()
            back_from_video.emit()
