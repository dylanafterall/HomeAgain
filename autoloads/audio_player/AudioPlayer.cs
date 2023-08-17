using Godot;

public partial class AudioPlayer : Node
{
    // -------------------------------------------------------------------------
    // private variables -------------------------------------------------------
    
    private AudioStreamPlayer _musicStream;
    private AudioStreamPlayer _sfxStream;

    // -------------------------------------------------------------------------
    // built-in virtual methods ------------------------------------------------

    // called when both the node and its children have entered the scene tree
    public override void _Ready()
    {
        _musicStream = GetNode<AudioStreamPlayer>("MusicAudioStream");
        _musicStream.Finished += OnMusicPlayerFinished;
        
        _sfxStream = GetNode<AudioStreamPlayer>("SFXAudioStream");
    }

    // -------------------------------------------------------------------------
    // public methods ----------------------------------------------------------
    
    public void PlaySFX(AudioStream asset)
    {
        _sfxStream.Stream = asset;
        _sfxStream.Play();
    }

    public bool IsMusicPlaying()
    {
        return _musicStream.Playing;
    }

    public void PlayMusic(AudioStream asset)
    {
        StopMusic();
        _musicStream.Stream = asset;
        _musicStream.Play();
    }

    public void StopMusic()
    {
        _musicStream.Stop();
    }

    // -------------------------------------------------------------------------
    // private methods ---------------------------------------------------------

    private void OnMusicPlayerFinished()
    {
        _musicStream.Play();
    }
}
