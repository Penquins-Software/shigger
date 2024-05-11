using Godot;
using System;

public partial class GroundChunk : Node2D
{
    public static AudioStream[] SFXDig = new AudioStream[]
    {
        ResourceLoader.Load<AudioStream>("res://audio/sfx/dig1.mp3"),
        ResourceLoader.Load<AudioStream>("res://audio/sfx/dig_2.mp3"),
    };
    public static AudioStream[] SFXBreak = new AudioStream[] 
    {
        ResourceLoader.Load<AudioStream>("res://audio/sfx/break1.mp3"),
        ResourceLoader.Load<AudioStream>("res://audio/sfx/break2.mp3"),
    };

    [Export]
    private GroundChunkType _type;
    [Export]
    private int _hp = 1;
    [Export]
    private int _points = 1;

    [Export]
    private Area2D _area2D;
    [Export]
    private AnimatedSprite2D _animatedSprite2D;


    public int Points => _points;


    public override void _EnterTree()
    {
        _area2D.AreaEntered += (area) => 
        {
            if (area is MonsterArea) 
            {
                Destroy(Game.CurrentBPMInSeconds, play_sound: false);
            }
        };
    }

    public override void _Process(double delta)
    {
        base._Process(delta);
    }


    public bool Dig(Player player) 
    {
        _hp -= Player.Damage;

        if (_hp <= 0) 
        {
            return true;
        }

        HitAnim();
        return false;
    }

    public async void Destroy(double time, bool explode = false, bool play_sound = true)
    {
        if (explode)
        {
            _animatedSprite2D.Play();
        }

        if (play_sound)
        {
            SFXAudioStreamPlayer.Instance.PlaySFX(SFXBreak[GD.RandRange(0, SFXBreak.Length - 1)]);
        }

        Modulate = new Color(0.8f, 0.2f, 0.4f);

        await ToSignal(GetTree().CreateTimer(time), "timeout");

        QueueFree();
    }

    public async void HitAnim()
    {
        Modulate = new Color(0.5f, 0.5f, 0.5f);

        SFXAudioStreamPlayer.Instance.PlaySFX(SFXDig[GD.RandRange(0, SFXBreak.Length - 1)]);

        await ToSignal(GetTree().CreateTimer(Game.CurrentBPMInSeconds1_2), "timeout");

        Modulate = Colors.White;
    }
}
