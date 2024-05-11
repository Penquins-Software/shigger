using Godot;
using System;

public partial class Metronome : AudioStreamPlayer
{
    [Export]
    private Game _game;

    [Export]
    private bool _enable;

    public override void _Ready()
    {
        if (_enable)
        {
            _game.Bit += () => Play();
        }
    }
}
