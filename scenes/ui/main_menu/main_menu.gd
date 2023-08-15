class_name MainMenu
extends CanvasLayer

# ------------------------------------------------------------------------------
# @export variables ------------------------------------------------------------

@export var background_music: AudioStream

@export_group("SceneSwitcher Settings")
@export var enter_sfx: AudioStream
@export var settings_sfx: AudioStream
@export_file var settings_scene
@export_group("")


# ------------------------------------------------------------------------------
# @onready variables -----------------------------------------------------------

@onready var enter_button: Button = %EnterButton
@onready var settings_button: Button = %SettingsButton
@onready var exit_button: Button = %ExitButton
@onready var earth_video: VideoStreamPlayer = %EarthVideoPlayer


# ------------------------------------------------------------------------------
# built-in virtual methods -----------------------------------------------------

# called when both the node and its children have entered the scene tree
func _ready() -> void:
    # lower master volume (bus index 0) when loading into main menu
    AudioServer.set_bus_volume_db(0, -7.5)
        
    if !MusicPlayer.IsPlaying():
        MusicPlayer.PlayMusic(background_music)
        
    var buttons = get_tree().get_nodes_in_group("Buttons")
    for button in buttons:
        button.mouse_entered.connect(button.grab_focus)
        button.focus_entered.connect(_move_to_button.bind(button))
        button.focus_exited.connect(_move_from_button.bind(button)) 
        button.pressed.connect(_animate_button_press.bind(button))
        
    earth_video.finished.connect(_on_earth_video_finished)
        
    enter_button.grab_focus()
    

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
        enter_button:
            SceneSwitcher.PlayAudioEffect(enter_sfx)
        settings_button:
            SceneSwitcher.PlayAudioEffect(settings_sfx)
            SceneSwitcher.GoToScene(settings_scene)
        exit_button:
            get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
            get_tree().quit()
            
func _on_earth_video_finished():
    earth_video.play()