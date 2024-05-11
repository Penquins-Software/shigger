using Godot;
using System;

public partial class HUD : CanvasLayer
{
    [Export]
    private Game _game;
    [Export]
    private Button _pauseButton;
    [Export]
    private RichTextLabel _points;
    [Export]
    private Rhythm _rhythm;
    [Export]
    private Skills _skills;


    public Button PauseButton => _pauseButton;

    public Game Game => _game;
    public Rhythm Rhythm => _rhythm;
    public Skills Skills => _skills;


    public async void SetPoints(int value, int multiplier, int hits) 
    {
        await ToSignal(GetTree().CreateTimer(Game.CurrentBPMInSeconds), "timeout");

        _points.Text = $"[center]Очков: {value}\n\nСерия: {hits} (X{multiplier})";
    }
}
