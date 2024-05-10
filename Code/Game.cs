using Godot;
using System;

public partial class Game : Node2D
{
    [Signal]
    public delegate void BitEventHandler();
    
    private double _currentTime = 0.0;

    [Export]
    private HUD _hud;
    [Export]
    private Pause _pause;
    [Export]
    private World _world;
    [Export]
    private Player _player;
    [Export]
    private Monster _monster;

    [Export(PropertyHint.File, "*.tscn")] private string _menuSceneFile;


    public static int Points = 0;

    public static double CurrentBPMInSeconds;
    public static double CurrentBPMInSecondsHalf;
    public static double CurrentBPMInSeconds3per4;


    public override void _Ready()
    {
        Points = 0;
        CurrentBPMInSeconds = Constantns.BPM_75;
        CurrentBPMInSecondsHalf = CurrentBPMInSeconds / 2.0;
        CurrentBPMInSeconds3per4 = CurrentBPMInSeconds * 3.0 / 4.0;

        _hud.PauseButton.Pressed += () => Pause();
        _pause.ContinueButton.Pressed += () => Continue();
        _pause.ReturnButton.Pressed += () => ToMenu();

        Bit += () => _world.Bit();
        Bit += () => _player.StartDig();
        Bit += () => _monster.Move();

        _player.Die += () => EndGame();
    }

    public override void _Process(double delta)
    {
        if (_pause.Visible)
        {
            return;
        }

        _currentTime += delta;
        if (_currentTime > CurrentBPMInSeconds)
        {
            _currentTime = _currentTime - CurrentBPMInSeconds;
            EmitSignal(SignalName.Bit);
        }
    }

    public void Pause() 
    {
        _hud.Hide();
        _pause.Show();
        _pause.Result.Text = $"[center]Ваш результат: {Points} очков!";
        _world.ProcessMode = ProcessModeEnum.Disabled;
    }

    public void Continue()
    {
        _hud.Show();
        _pause.Hide();
        _world.ProcessMode = ProcessModeEnum.Inherit;
    }

    public void ToMenu()
    {
        LootLockerClient.SubmitScore(Points);
        GetTree().CallDeferred("change_scene_to_file", _menuSceneFile);
    }

    public void EndGame() 
    {
        ToMenu();
    }
}
