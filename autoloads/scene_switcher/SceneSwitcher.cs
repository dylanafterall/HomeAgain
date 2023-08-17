using Godot;

public partial class SceneSwitcher : Node
{
    // -------------------------------------------------------------------------
    // public variables --------------------------------------------------------
    
    public Node PreviousScene { get; set; }
    public Node NextScene { get; set; }
    
    // -------------------------------------------------------------------------
    // private variables -------------------------------------------------------
    
    private Node CurrentScene { get; set; }
    private PackedScene _nextScenePacked;

    // -------------------------------------------------------------------------
    // built-in virtual methods ------------------------------------------------
    
    // called when both the node and its children have entered the scene tree
    public override void _Ready()
    {
        Viewport root = GetTree().Root;
        // the last child of root is the loaded (non-autoload) scene
        CurrentScene = root.GetChild(root.GetChildCount() - 1);
    }

    // -------------------------------------------------------------------------
    // public methods ----------------------------------------------------------

    // manually prepare the next scene 
    public void PackNextScene(string scenePath)
    {
        _nextScenePacked = (PackedScene)GD.Load(scenePath);
    }

    // manually delete previous scene (not needed if SwitchSceneAndFree used)
    public void FreePreviousScene()
    {
        PreviousScene.QueueFree();
    }

    // free (delete) the outgoing scene 
    // pro: less cpu and memory usage
    // con: returning to previous scene requires reloading
    public void SwitchSceneAndFree()
    {
        // save reference of scene we're exiting
        PreviousScene = CurrentScene;

        // instance new scene and add to root
        CurrentScene = _nextScenePacked.Instantiate();
        GetTree().Root.AddChild(CurrentScene);
        
        // queue previous scene and its children for deletion at end of frame
        PreviousScene.QueueFree();
        
        // optional, make compatible with SceneTree.change_scene_to_file() API
        GetTree().CurrentScene = CurrentScene;
    }

    // hide (change visibility) of outgoing scene
    // pro: previous scene's data still available, still able to update
    // pro: nodes are still members of groups (groups belong to SceneTree)
    // con: more data kept in memory
    // con: cpu now processing multiple scenes simultaneously 
    // con: requires setting node visibilities, collision detection, etc.
    public void SwitchSceneAndHide()
    {
    }

    // remove outgoing scene from tree (but not deleted from memory)
    // pro: simpler than changing visibilities, just remove/add child node
    // pro: cpu processing stops for previous scene
    // con: cpu processing stoppage means previous scene data can grow stale
    public void SwitchSceneAndRemove()
    {
        PreviousScene = CurrentScene;
        
        CurrentScene = _nextScenePacked.Instantiate();
        GetTree().Root.AddChild(CurrentScene);
        
        // rather than free/delete the outgoing scene, only remove from tree
        GetTree().Root.RemoveChild(PreviousScene);
        
        GetTree().CurrentScene = CurrentScene;
    }
}
