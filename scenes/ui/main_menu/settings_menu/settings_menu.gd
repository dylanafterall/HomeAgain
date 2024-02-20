class_name SettingsMenu
extends Control

# ------------------------------------------------------------------------------
# @export variables ------------------------------------------------------------

@export_group("SceneSwitcher Settings")
@export_file var back_scene
@export_group("")


# ------------------------------------------------------------------------------
# @onready variables -----------------------------------------------------------

@onready var video_button: Button = %VideoButton
@onready var audio_button: Button = %AudioButton
@onready var accessibility_button: Button = %AccessibilityButton
@onready var controller_button: Button = %ControllerButton
@onready var keyboard_button: Button = %KeyboardButton
@onready var credits_button: Button = %CreditsButton
@onready var back_button: Button = %BackButton
@onready var moon_video: VideoStreamPlayer = %MoonVideoPlayer
@onready var animation_player: AnimationPlayer = %SettingsAnimations
@onready var base_settings: CanvasLayer = %BaseSettings
@onready var audio_settings: CanvasLayer = %AudioSettings
@onready var video_settings: CanvasLayer = %VideoSettings


# ------------------------------------------------------------------------------
# built-in virtual methods -----------------------------------------------------

# called when both the node and its children have entered the scene tree
func _ready() -> void:
    ResourceLoader.load_threaded_request(back_scene)
        
    var buttons = get_tree().get_nodes_in_group("SettingsButtons")
    for button in buttons:
        button.mouse_entered.connect(button.grab_focus)
        button.focus_entered.connect(_move_to_button.bind(button))
        button.focus_exited.connect(_move_from_button.bind(button)) 
        button.pressed.connect(_animate_button_press.bind(button))
        
    audio_settings.back_from_audio.connect(_back_from_audio)
    video_settings.back_from_video.connect(_back_from_video)
    
    moon_video.finished.connect(_on_moon_video_finished)
    
    video_button.grab_focus()


# ------------------------------------------------------------------------------
# private methods --------------------------------------------------------------

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
    button.release_focus()
    
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
    
    
func _animate_button_press(button: Button) -> void:
    match button:
        video_button:
            animation_player.play("base_to_video")
        audio_button:
            animation_player.play("base_to_audio")
        accessibility_button:
            print("accessibility")
        controller_button:
            print("controller")
        keyboard_button:
            print("keyboard")
        credits_button:
            print("credits")
        back_button:
            if ResourceLoader.load_threaded_get_status(back_scene) == ResourceLoader.THREAD_LOAD_LOADED:
                SceneSwitcher.SwitchSceneAndFree(ResourceLoader.load_threaded_get(back_scene), "fade_to_black")
            elif ResourceLoader.load_threaded_get_status(back_scene) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
                print("scene still loading")
            else:
                print("scene failed to load")
            
            
func _on_moon_video_finished():
    moon_video.play()
    
    
func _back_from_video():
    animation_player.play_backwards("base_to_video")
    
    
func _back_from_audio():
    animation_player.play_backwards("base_to_audio")
