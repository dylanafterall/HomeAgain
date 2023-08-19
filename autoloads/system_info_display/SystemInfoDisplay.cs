using Godot;

public partial class SystemInfoDisplay : CanvasLayer
{
    // -------------------------------------------------------------------------
    // private variables -------------------------------------------------------

    private WorldEnvironment _worldEnvironment;
    private Label _fpsLabel;
    private Label _masterVolumeLabel;
    private Label _musicVolumeLabel;
    private Label _sfxVolumeLabel;
    private Label _speechVolumeLabel;
    private Label _ambienceVolumeLabel;
    private Label _fullscreenLabel;
    private Label _resolutionLabel;
    private Label _vsyncLabel;
    private Label _maxfpsLabel;
    private Label _antiAliasLabel;
    private Label _brightnessLabel;
    private Label _contrastLabel;
    private Label _saturationLabel;

    // -------------------------------------------------------------------------
    // built-in virtual methods ------------------------------------------------

    // called when both the node and its children have entered the scene tree
    public override void _Ready()
    {
        _fpsLabel = GetNode<Label>("InfoMenu/CurrentFPS");
        ShowFPS();
        
        _masterVolumeLabel    = GetNode<Label>("InfoMenu/MasterVolume/MasterVolValue");
        _musicVolumeLabel     = GetNode<Label>("InfoMenu/MusicVolume/MusicVolValue");
        _sfxVolumeLabel       = GetNode<Label>("InfoMenu/SFXVolume/SFXVolValue");
        _speechVolumeLabel    = GetNode<Label>("InfoMenu/SpeechVolume/SpeechVolValue");
        _ambienceVolumeLabel  = GetNode<Label>("InfoMenu/AmbienceVolume/AmbienceVolValue");
        _fullscreenLabel      = GetNode<Label>("InfoMenu/Fullscreen/FullscreenValue");
        _resolutionLabel      = GetNode<Label>("InfoMenu/Resolution/ResolutionValue");
        _vsyncLabel           = GetNode<Label>("InfoMenu/VSync/VSyncValue");
        _maxfpsLabel          = GetNode<Label>("InfoMenu/MaxFPS/MaxFPSValue");
        _antiAliasLabel       = GetNode<Label>("InfoMenu/AntiAlias/AntiAliasValue");
        _brightnessLabel      = GetNode<Label>("InfoMenu/Brightness/BrightnessValue");
        _contrastLabel        = GetNode<Label>("InfoMenu/Contrast/ContrastValue");
        _saturationLabel      = GetNode<Label>("InfoMenu/Saturation/SaturationValue");
        _worldEnvironment     = GetNode<WorldEnvironment>("/root/WorldEnv");
        UpdateSettings();
    }

    // called every frame, as often as possible   
    public override void _Process(double delta)
    {
        if (_fpsLabel.Visible)
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

    public void UpdateSettings()
    {
        int masterIndex = AudioServer.GetBusIndex("Master");
        float masterVol = Mathf.DbToLinear(AudioServer.GetBusVolumeDb(masterIndex));
        _masterVolumeLabel.Text = masterVol.ToString();
        
        int musicIndex = AudioServer.GetBusIndex("Music");
        float musicVol = Mathf.DbToLinear(AudioServer.GetBusVolumeDb(musicIndex));
        _musicVolumeLabel.Text = musicVol.ToString();
            
        int sfxIndex = AudioServer.GetBusIndex("SFX");
        float sfxVol = Mathf.DbToLinear(AudioServer.GetBusVolumeDb(sfxIndex));
        _sfxVolumeLabel.Text = sfxVol.ToString();
            
        int speechIndex = AudioServer.GetBusIndex("Speech");
        float speechVol = Mathf.DbToLinear(AudioServer.GetBusVolumeDb(speechIndex));
        _speechVolumeLabel.Text = speechVol.ToString();
           
        int ambienceIndex = AudioServer.GetBusIndex("Ambience");
        float ambienceVol = Mathf.DbToLinear(AudioServer.GetBusVolumeDb(ambienceIndex));
        _ambienceVolumeLabel.Text = ambienceVol.ToString();

        DisplayServer.WindowMode windowMode = DisplayServer.WindowGetMode();
        _fullscreenLabel.Text = windowMode.ToString();

        Vector2I windowSize = GetViewport().GetWindow().Size;
        _resolutionLabel.Text = windowSize.ToString();

        DisplayServer.VSyncMode vSyncMode = DisplayServer.WindowGetVsyncMode();
        _vsyncLabel.Text = vSyncMode.ToString();

        int maxFps = Engine.MaxFps;
        _maxfpsLabel.Text = maxFps.ToString();
        
        Viewport.Msaa antiAlias = GetViewport().GetWindow().Msaa2D;
        _antiAliasLabel.Text = antiAlias.ToString();

        float brightness = _worldEnvironment.Environment.AdjustmentBrightness;
        _brightnessLabel.Text = brightness.ToString();

        float contrast = _worldEnvironment.Environment.AdjustmentContrast;
        _contrastLabel.Text = contrast.ToString();

        float saturation = _worldEnvironment.Environment.AdjustmentSaturation;
        _saturationLabel.Text = saturation.ToString();
    }
    
    public void ShowSettings()
    {
        _masterVolumeLabel.Visible = true;
        _musicVolumeLabel.Visible = true;
        _sfxVolumeLabel.Visible = true;
        _speechVolumeLabel.Visible = true;
        _ambienceVolumeLabel.Visible = true;
        _fullscreenLabel.Visible = true;
        _resolutionLabel.Visible = true;
        _vsyncLabel.Visible = true;
        _maxfpsLabel.Visible = true;
        _antiAliasLabel.Visible = true;
        _brightnessLabel.Visible = true;
        _contrastLabel.Visible = true;
        _saturationLabel.Visible = true;
    }

    public void HideSettings()
    {
        _masterVolumeLabel.Visible = false;
        _musicVolumeLabel.Visible = false;
        _sfxVolumeLabel.Visible = false;
        _speechVolumeLabel.Visible = false;
        _ambienceVolumeLabel.Visible = false;
        _fullscreenLabel.Visible = false;
        _resolutionLabel.Visible = false;
        _vsyncLabel.Visible = false;
        _maxfpsLabel.Visible = false;
        _antiAliasLabel.Visible = false;
        _brightnessLabel.Visible = false;
        _contrastLabel.Visible = false;
        _saturationLabel.Visible = false;
    }
}
