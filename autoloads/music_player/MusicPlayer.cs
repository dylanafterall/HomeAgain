using Godot;

public partial class MusicPlayer : Node
{
    // -------------------------------------------------------------------------
    // signals -----------------------------------------------------------------


    // -------------------------------------------------------------------------
    // enums -------------------------------------------------------------------


    // -------------------------------------------------------------------------
    // constants ---------------------------------------------------------------


    // -------------------------------------------------------------------------
    // @export variables -------------------------------------------------------


    // -------------------------------------------------------------------------
    // public variables --------------------------------------------------------


    // -------------------------------------------------------------------------
    // private variables -------------------------------------------------------
    private AudioStreamPlayer _audioStreamPlayer;

    // -------------------------------------------------------------------------
    // built-in virtual methods ------------------------------------------------

    // called every time the node enters the scene tree
    public override void _EnterTree()
    {
        base._EnterTree();
    }
    
    // called when both the node and its children have entered the scene tree
    public override void _Ready()
    {
        _audioStreamPlayer = GetNode<AudioStreamPlayer>("MusicAudioStream");
        _audioStreamPlayer.Finished += OnMusicPlayerFinished;
    }
    
    // called when node is about to leave scene tree, after all children
    //  receive the _exit_tree() callback
    public override void _ExitTree()
    {
        base._ExitTree();
    }

    // called every frame, as often as possible   
    public override void _Process(double delta)
    {
        base._Process(delta);
    }
    
    // called every physics frame
    public override void _PhysicsProcess(double delta)
    {
        base._PhysicsProcess(delta);
    }
    
    // called once for every event
    public override void _UnhandledInput(InputEvent @event)
    {
        base._UnhandledInput(@event);
    }

    // called once for every event, before _unhandled_input(), allowing you to 
    //   consume some events
    public override void _Input(InputEvent @event)
    {
        base._Input(@event);
    }

    
    // -------------------------------------------------------------------------
    // public methods ----------------------------------------------------------

    public bool IsPlaying()
    {
        return _audioStreamPlayer.Playing;
    }

    public void PlayMusic(AudioStream asset)
    {
        StopMusic();
        _audioStreamPlayer.Stream = asset;
        _audioStreamPlayer.Play();
    }

    public void StopMusic()
    {
        _audioStreamPlayer.Stop();
    }

    // -------------------------------------------------------------------------
    // private methods ---------------------------------------------------------

    private void OnMusicPlayerFinished()
    {
        _audioStreamPlayer.Play();
    }

    // -------------------------------------------------------------------------
    // subclasses --------------------------------------------------------------
}
