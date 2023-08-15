class_name VideoSettings
extends CanvasLayer

# ------------------------------------------------------------------------------
# @export variables ------------------------------------------------------------

@export_group("SceneSwitcher Settings")
@export_file var back_scene
@export_group("")


# ------------------------------------------------------------------------------
# private variables ------------------------------------------------------------

var _resolutions: Dictionary = {
    "1280 x 720":Vector2(1280, 720),
    "1920 x 1080":Vector2(1920, 1080),
    "2560 x 1440":Vector2(2560, 1440),
    "3840 x 2160":Vector2(3840, 2160),
    "Native Resolution":Vector2(0,0),
}

var _aa_options: Dictionary = {
    "Disabled (Fastest)":Viewport.MSAA_DISABLED,
    "2x (Average)":Viewport.MSAA_2X,
    "4x (Slow)":Viewport.MSAA_4X,
    "8x (Slowest)":Viewport.MSAA_8X,
}

var _maxfps_options: Dictionary = {
    "30":30,
    "60":60,
    "120":120,
    "240":240,
    "No Limit":0,
}


# ------------------------------------------------------------------------------
# @onready variables -----------------------------------------------------------

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
    var option_buttons = get_tree().get_nodes_in_group("OptionButtons")
    for option_button in option_buttons:
        option_button.mouse_entered.connect(option_button.grab_focus)
        option_button.focus_entered.connect(_move_to_object.bind(option_button))
        option_button.focus_exited.connect(_move_from_object.bind(option_button))
        option_button.item_selected.connect(_optionbutton_action.bind(option_button))
        
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
    _resolutions["Native Resolution"] = DisplayServer.screen_get_size()
        
    add_resolutions()
    add_aa_options()
    add_maxfps_options()
    
    reset_defaults()
    display_button.grab_focus()


# ------------------------------------------------------------------------------
# private methods --------------------------------------------------------------

func add_resolutions() -> void:
    for resolution in _resolutions:
        resolution_button.add_item(resolution)
    

func add_aa_options() -> void:
    for aa_option in _aa_options:
        aa_button.add_item(aa_option)
        
        
func add_maxfps_options() -> void:
    for maxfps_option in _maxfps_options:
        max_fps_button.add_item(maxfps_option)
        
        
func _move_to_object(object) -> void:
    var label: Label = _labels[object]
    label.add_theme_color_override("font_color", label.get_theme_color("nasa_white_color"))
    label.get_child(0).visible = true	
    label.get_child(1).visible = true	
    
    if object is CheckButton:
        object.add_theme_icon_override("checked", object.get_theme_icon("checked_nasa"))
        object.add_theme_icon_override("unchecked", object.get_theme_icon("unchecked_nasa"))
        
    if object is OptionButton:
        if object.disabled == true:
            object.add_theme_stylebox_override("focus", object.get_theme_stylebox("disabled"))
        else:
            object.add_theme_color_override("font_outline_color", object.get_theme_color("nasa_red_color"))
        
    
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
            var new_size: Vector2 = _resolutions.get(resolution_button.get_item_text(index))
            get_viewport().set_size(new_size)
        aa_button:
            var new_aa = _aa_options.get(aa_button.get_item_text(index))
            get_viewport().msaa_2d = new_aa
        max_fps_button:
            var new_maxfps = _maxfps_options.get(max_fps_button.get_item_text(index))
            Engine.set_max_fps(new_maxfps)
            

func _checkbutton_action(pressed: bool, button: CheckButton) -> void:
    if pressed:
        match button:
            display_button:
                resolution_button.select(_resolutions.size() - 1)   # native res
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
        
    
func _button_action(object) -> void:	
    match object:
        reset_button:
            reset_defaults()
        back_button:
            print("clicked back")
            SceneSwitcher.GoToScene(back_scene)
            
            
func reset_defaults() -> void:
    display_button.button_pressed = false
    resolution_button.select(_resolutions.size() - 1)    # native res by default
    vsync_button.button_pressed = true
    max_fps_button.select(1)                            # 60 fps cap by default
    max_fps_button.disabled = true                      # due to vsync default
    show_fps_button.button_pressed = false
    aa_button.select(2)                                 # x4 msaa by default
    brightness_slider.set_value(WorldEnv.get_environment().get_adjustment_brightness()) 
    contrast_slider.set_value(WorldEnv.get_environment().get_adjustment_contrast()) 
    saturation_slider.set_value(WorldEnv.get_environment().get_adjustment_saturation()) 
