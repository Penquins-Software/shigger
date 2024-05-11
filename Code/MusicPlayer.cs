using Godot;
using System;

public partial class MusicPlayer : AudioStreamPlayer
{
    [Export]
    private Game _game;

    [Export]
	private AudioStream _audio75bpm;
    [Export]
    private AudioStream _audio100bpm;
    [Export]
    private AudioStream _audio120bpm;


    public void Play75BPM() 
    {
        Stream = _audio75bpm;
        Play();
        _game.SetBPM(Constantns.BPM_75);
    }

    public void Play100BPM()
    {
        Stream = _audio100bpm;
        Play();
        _game.SetBPM(Constantns.BPM_100);
    }

    public void Play120BPM()
    {
        Stream = _audio120bpm;
        Play();
        _game.SetBPM(Constantns.BPM_120);
    }
}
