using Godot;
using System.Collections.Generic; 

public partial class SceneSwitcher : Node
{
    // -------------------------------------------------------------------------
    // public variables --------------------------------------------------------
    
    public Node PreviousScene { get; set; }
    public Node NextScene { get; set; }
    
    // -------------------------------------------------------------------------
    // private variables -------------------------------------------------------
    
    private Node CurrentScene { get; set; }
    private AnimationPlayer _animationPlayer;

    // -------------------------------------------------------------------------
    // built-in virtual methods ------------------------------------------------
    
    // called when both the node and its children have entered the scene tree
    public override void _Ready()
    {
        Viewport root = GetTree().Root;
        // the last child of root is the loaded (non-autoload) scene
        CurrentScene = root.GetChild(root.GetChildCount() - 1);
        
        _animationPlayer = GetNode<AnimationPlayer>("SceneSwitchAnimation");
    }

    // -------------------------------------------------------------------------
    // public methods ----------------------------------------------------------

    // manually delete previous scene (not needed if SwitchSceneAndFree used)
    public void FreePreviousScene()
    {
        PreviousScene.QueueFree();
    }

    // free (delete) the outgoing scene 
    // pro: less cpu and memory usage
    // con: returning to previous scene requires reloading
    public async void SwitchSceneAndFree(PackedScene next, string animation)
    {
        // save reference of scene we're exiting
        PreviousScene = CurrentScene;
        
        _animationPlayer.Play(animation);
        await ToSignal(_animationPlayer, "animation_finished");

        // instance new scene and add to root
        CurrentScene = next.Instantiate();
        GetTree().Root.AddChild(CurrentScene);
        
        _animationPlayer.PlayBackwards(animation);
        
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
    public async void SwitchSceneAndHide(PackedScene next)
    {
    }

    // remove outgoing scene from tree (but not deleted from memory)
    // pro: simpler than changing visibilities, just remove/add child node
    // pro: cpu processing stops for previous scene
    // con: cpu processing stoppage means previous scene data can grow stale
    public async void SwitchSceneAndRemove(PackedScene next, string animation)
    {
        PreviousScene = CurrentScene;
        
        _animationPlayer.Play(animation);
        await ToSignal(_animationPlayer, "animation_finished");
        
        CurrentScene = next.Instantiate();
        GetTree().Root.AddChild(CurrentScene);
        
        _animationPlayer.PlayBackwards(animation);
        
        // rather than free/delete the outgoing scene, only remove from tree
        GetTree().Root.RemoveChild(PreviousScene);
        
        GetTree().CurrentScene = CurrentScene;
    }
}
