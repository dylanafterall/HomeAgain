using Godot;

public partial class MusicPlayer : Node
{
    // -------------------------------------------------------------------------
    // private variables -------------------------------------------------------
    
    private AudioStreamPlayer _audioStreamPlayer;

    // -------------------------------------------------------------------------
    // built-in virtual methods ------------------------------------------------

    // called when both the node and its children have entered the scene tree
    public override void _Ready()
    {
        _audioStreamPlayer = GetNode<AudioStreamPlayer>("MusicAudioStream");
        _audioStreamPlayer.Finished += OnMusicPlayerFinished;
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
}
