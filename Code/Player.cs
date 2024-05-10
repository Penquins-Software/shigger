using Godot;
using Settings;
using System;

public partial class Player : Node2D
{
    [Signal]
    public delegate void MoveLeftEventHandler();
    [Signal]
    public delegate void MoveRightEventHandler();
    [Signal]
    public delegate void DigEventHandler();
    [Signal]
    public delegate void DieEventHandler();

    [Export]
    private AnimationPlayer _animationPlayer;
    [Export]
    private AnimationPlayer _rotateAnimationPlayer;
    [Export]
    private AnimatedSprite2D _animatedSprite2D;
    [Export]
    private AnimatedSprite2D _effectAnimatedSprite2D;

    [Export]
    private Area2D _area2D;


    private bool _digging = false;
    private double _diggingTime = 0;


	public override void _Ready()
	{
        _area2D.AreaEntered += (area) =>
        {
            if (area is MonsterArea)
            {
                EmitSignal(SignalName.Die);
            }
        };

        _animatedSprite2D.AnimationFinished += () => 
        {
            if (_animatedSprite2D.Animation == "digging")
            {
                _animatedSprite2D.Play("idle");
                _animatedSprite2D.Modulate = Colors.White;
                _digging = false;
            }
        };
    }

    public override void _Process(double delta)
    {
        if (_digging) 
        {
            _diggingTime -= delta;
        }
    }

    public override void _Input(InputEvent @event)
    {
        if (_digging && _diggingTime > 0) 
        {
            return;
        }

        if (@event.IsActionPressed("left"))
        {
            EmitSignal(SignalName.MoveLeft);
        }
        else if (@event.IsActionPressed("right"))
        {
            EmitSignal(SignalName.MoveRight);
        }
    }

    public void StartDig() 
    {
        EmitSignal(SignalName.Dig);
    }

    public void PlayDigAnim() 
    {
        if (Config.CameraShaking)
        {
            _animationPlayer.Play("Shake");
        }
        _animatedSprite2D.Play("digging");
        _animatedSprite2D.Modulate = new Color(0.7f, 0.7f, 0.7f);
        _effectAnimatedSprite2D.Play("default");
        _digging = true;
        _diggingTime = Game.CurrentBPMInSeconds3per4;
    }

    public void SetBPMInSeconds(double bpm) 
    {
    }

    public void RotateCamera90() 
    {
        _rotateAnimationPlayer.Play("RotateToLeft");
    }

    public void RotateCamera180()
    {
        _rotateAnimationPlayer.Play("FlipFromLeft");
    }
}
