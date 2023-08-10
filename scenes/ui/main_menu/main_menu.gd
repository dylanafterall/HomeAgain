class_name MainMenu
extends CanvasLayer

# ------------------------------------------------------------------------------
# signals ----------------------------------------------------------------------


# ------------------------------------------------------------------------------
# enums ------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# constants --------------------------------------------------------------------


# ------------------------------------------------------------------------------
# @export variables ------------------------------------------------------------

@export var background_music: AudioStream

@export_group("SceneSwitcher Settings")
@export var enter_sfx: AudioStream
@export var settings_sfx: AudioStream
@export_file var settings_scene
@export_group("")


# ------------------------------------------------------------------------------
# public variables -------------------------------------------------------------


# ------------------------------------------------------------------------------
# private variables ------------------------------------------------------------


# ------------------------------------------------------------------------------
# @onready variables -----------------------------------------------------------


# ------------------------------------------------------------------------------
# built-in virtual methods -----------------------------------------------------

# called every time the node enters the scene tree
func _enter_tree() -> void:
    pass
    
    
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
        
    %EarthVideoPlayer.finished.connect(_on_earth_video_finished)
        
    %EnterButton.grab_focus()
    
    
# called when node is about to leave scene tree, after all children receive the 
#   _exit_tree() callback
func _exit_tree() -> void:
    pass
 
 
# called every frame, as often as possible   
func _process(_delta: float) -> void:
    pass
    
    
# called every physics frame
func _physics_process(_delta: float) -> void:
    pass
    
    
# called once for every event
func _unhandled_input(_event: InputEvent) -> void:
    pass
    
    
# called once for every event, before _unhandled_input(), allowing you to 
#   consume some events
func _input(_event: InputEvent) -> void:
    pass


# ------------------------------------------------------------------------------
# public methods ---------------------------------------------------------------


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
    var enter = %EnterButton
    var settings = %SettingsButton
    var exit = %ExitButton
    
    match button:
        enter:
            SceneSwitcher.PlayAudioEffect(enter_sfx)
            #SceneSwitcher.GoToScene(game_scene)
        settings:
            SceneSwitcher.PlayAudioEffect(settings_sfx)
            SceneSwitcher.GoToScene(settings_scene)
        exit:
            get_tree().quit()
            
func _on_earth_video_finished():
    %EarthVideoPlayer.play()


# ------------------------------------------------------------------------------
# subclasses -------------------------------------------------------------------