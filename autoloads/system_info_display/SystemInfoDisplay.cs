using Godot;

public partial class SystemInfoDisplay : CanvasLayer
{
    // -------------------------------------------------------------------------
    // private variables -------------------------------------------------------
    
    private Label _fpsLabel;
    private bool _fpsVisible;

    // -------------------------------------------------------------------------
    // built-in virtual methods ------------------------------------------------

    // called when both the node and its children have entered the scene tree
    public override void _Ready()
    {
        _fpsLabel = GetNode<Label>("CurrentFPS");
        HideFPS();
    }

    // called every frame, as often as possible   
    public override void _Process(double delta)
    {
        if (_fpsVisible)
        {
            _fpsLabel.Text = ((int)Engine.GetFramesPerSecond()).ToString();
        }
    }

    // -------------------------------------------------------------------------
    // public methods ----------------------------------------------------------
    
    public void ShowFPS()
    {
        _fpsLabel.Visible = true;
    }

    public void HideFPS()
    {
        _fpsLabel.Visible = false;
    }
}
