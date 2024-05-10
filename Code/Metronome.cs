using Godot;
using System;

public partial class Metronome : AudioStreamPlayer
{
    private const double BPM_75 = 0.8;
    private double _currentTime = 0.0;


	public override void _Process(double delta)
    {
        _currentTime += delta;
        if (_currentTime > BPM_75)
        {
            _currentTime = _currentTime - BPM_75;
            Play();
        }
    }
}
