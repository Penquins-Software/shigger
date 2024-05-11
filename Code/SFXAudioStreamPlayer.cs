using Godot;
using System;

public partial class SFXAudioStreamPlayer : AudioStreamPlayer
{
    private static SFXAudioStreamPlayer s_Instance;
    public static SFXAudioStreamPlayer Instance => s_Instance;


    public override void _Ready()
    {
        s_Instance = this;
    }

    public void PlaySFX(AudioStream stream) 
    {
        if (s_Instance == null)
        {
            return;
        }

        Stream = stream;
        Play();
    }
}
