using Godot;
using Settings;
using System;
using System.Collections.Generic;

public partial class Player : Node2D
{
    [Signal]
    public delegate void MoveLeftEventHandler();
    [Signal]
    public delegate void MoveRightEventHandler();
    [Signal]
    public delegate void DigEventHandler();
    [Signal]
    public delegate void InBitEventHandler();
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

    [Export]
    private Camera2D _camera2D;


    private bool _digging = false;
    private double _diggingTime = 0;

    private bool _bit_1_5 = false;
    private bool _bit_1_4 = false;
    private bool _bit_1_3 = false;
    private bool _bit_2_3 = false;
    private bool _bit_3_4 = false;
    private bool _bit_4_5 = false;
    private bool _action = false;

    private int _seriesOfHits = 0;

    private Vector2I _worldPosition;

    public Vector2I WorldPosition => _worldPosition;

    public int SeriesOfHits => _seriesOfHits;


    private List<SkillList> _skills = new List<SkillList>();
    public List<SkillList> Skills => _skills;

    public static int Damage = 1;

    public static bool Flashlight = false;
    public static bool Fugu = false;

    public static bool WideShovel = false;
    public static bool SidewaysShovel = false;
    public static bool Drill = false;


    public override void _Ready()
	{
        Damage = 1;

        Flashlight = false;
        Fugu = false;

        WideShovel = false;
        SidewaysShovel = false;
        Drill = false;

        if (!Config.CameraShaking) 
        {
            _camera2D.PositionSmoothingEnabled = false;
            _camera2D.RotationSmoothingEnabled = false;
        }

        _area2D.AreaEntered += (area) =>
        {
            if (area is MonsterArea)
            {
                if (Fugu)
                {
                    Fugu = false;
                    var monster = area.GetParent() as Monster;
                    monster.Stop(16);
                    monster.PlaceMonster(monster.WorldPosition - new Vector2I(0, 4));
                    Message.Create(this, Position, $"[color=green]Вас спасла рыба ФУГУ!");
                    Place(_worldPosition + new Vector2I(0, 1));
                }
                else
                {
                    EmitSignal(SignalName.Die);
                }
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

    public void GetFlashlight()
    {
        Flashlight = true;
        Item.TurnOnLight();
    }

    public override void _Input(InputEvent @event)
    {
        // Если действие уже было совершено.
        if (_action)
        {
            return;
        }

        if (@event.IsActionPressed("left"))
        {
            _action = true;
            if (_bit_2_3 || _bit_1_4)
            {
                EmitSignal(SignalName.MoveLeft);
                EmitSignal(SignalName.InBit);
                if (_bit_4_5)
                {
                    //Message.Create(this, Position, $"[color=green]Идеально!");
                }
            }
            else
            {
                _seriesOfHits = 0;
                Message.Create(this, Position, $"[color=purple]Мимо...");
            }
        }
        else if (@event.IsActionPressed("right"))
        {
            _action = true;
            if (_bit_2_3 || _bit_1_4)
            {
                EmitSignal(SignalName.MoveRight);
                EmitSignal(SignalName.InBit);
                if (_bit_4_5)
                {
                    //Message.Create(this, Position, $"[color=green]Идеально!");
                }
            }
            else
            {
                _seriesOfHits = 0;
                Message.Create(this, Position, $"[color=purple]Мимо...");
            }
        }
        else if (@event.IsActionPressed("dig"))
        {
            _action = true;
            if (_bit_2_3 || _bit_1_4)
            {
                EmitSignal(SignalName.Dig);
                EmitSignal(SignalName.InBit);
                if (_bit_4_5)
                {
                    //Message.Create(this, Position, $"[color=green]Идеально!");
                }
            }
            else
            {
                _seriesOfHits = 0;
                Message.Create(this, Position, $"[color=purple]Мимо...");
            }
        }
    }

    public void BitFull()
    {
        _bit_1_5 = true;
        _bit_1_4 = true;
        _bit_1_3 = true;
        _bit_2_3 = false;
        _bit_3_4 = false;
        _bit_4_5 = false;
    }

    public void Bit1_5()
    {
        _bit_1_5 = false;
    }

    public void Bit1_4()
    {
        _bit_1_4 = false;

        if (!_action) 
        {
            _seriesOfHits = 0;
        }

        _action = false;
    }

    public void Bit1_3()
    {
        _bit_1_3 = false;
    }

    public void Bit2_3()
    {
        _bit_2_3 = true;
    }

    public void Bit3_4() 
    {
        _bit_3_4 = true;
    }

    public void Bit4_5()
    {
        _bit_4_5 = true;
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
        _diggingTime = Game.CurrentBPMInSeconds3_4;
        AddHit();
    }

    public void SetBPMInSeconds(double bpm) 
    {
        _animatedSprite2D.SpeedScale = (float)(Constantns.BPM_75 / bpm);
        _animatedSprite2D.Frame = 0;
    }

    public void RotateCamera90() 
    {
        _rotateAnimationPlayer.Play("RotateToLeft");
    }

    public void RotateCamera180()
    {
        _rotateAnimationPlayer.Play("FlipFromLeft");
    }

    public void DoABarrelRoll()
    {
        _rotateAnimationPlayer.Play("DoABarrelRoll");
    }

    public void Place(Vector2I world_position)
    {
        _worldPosition = world_position;
        Position = _worldPosition * Constantns.FACTOR;
    }

    public void AddHit() 
    {
        _seriesOfHits++;
    }
}
