using Godot;

public partial class SceneSwitcher : Node
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
    private Node CurrentScene { get; set; }
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
        Viewport root = GetTree().Root;
        // the last child of root is the loaded (non-autoload) scene
        CurrentScene = root.GetChild(root.GetChildCount() - 1);

        _audioStreamPlayer = GetNode<AudioStreamPlayer>("SceneSwitchAudio");
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

    public void PlayAudioEffect(AudioStream asset)
    {
        _audioStreamPlayer.Stream = asset;
        _audioStreamPlayer.Play();
    }

    public void GoToScene(string path)
    {
        // defer load to later time, when no code from current scene running
        // DeferredGoToScene() only runs when CurrentScene is complete
        // avoids crash or unexpected behavior
        CallDeferred(MethodName.DeferredGoToScene, path);
    }
    
    // -------------------------------------------------------------------------
    // private methods ---------------------------------------------------------

    private void DeferredGoToScene(string path)
    {
        // now safe to remove CurrentScene
        CurrentScene.Free();
        
        // load new scene, instance it, add to active scene as child of root
        var nextScene = (PackedScene)GD.Load(path);
        CurrentScene = nextScene.Instantiate();
        GetTree().Root.AddChild(CurrentScene);
        
        // optional, make compatible with SceneTree.change_scene_to_file() API
        GetTree().CurrentScene = CurrentScene;
    }

    // -------------------------------------------------------------------------
    // subclasses --------------------------------------------------------------
}
