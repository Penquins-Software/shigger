using Godot;
using System;

public partial class GroundChunk : Node2D
{
    [Export]
    private GroundChunkType _type;
    [Export]
    private int _hp = 1;
    [Export]
    private int _points = 1;

    [Export]
    private Area2D _area2D;


    public int Points => _points;


    public override void _EnterTree()
    {
        _area2D.AreaEntered += (area) => 
        {
            if (area is MonsterArea) 
            {
                Destroy();
            }
        };
    }

    public override void _Process(double delta)
    {
        base._Process(delta);
    }


    public bool Dig() 
    {
        _hp -= 1;

        if (_hp <= 0) 
        {
            return true;
        }

        HitAnim();
        return false;
    }

    public async void Destroy()
    {
        Modulate = new Color(0.8f, 0.8f, 0.8f);

        await ToSignal(GetTree().CreateTimer(Game.CurrentBPMInSeconds), "timeout");

        QueueFree();
    }

    public async void HitAnim()
    {
        Modulate = new Color(0.5f, 0.5f, 0.5f);

        await ToSignal(GetTree().CreateTimer(Game.CurrentBPMInSeconds / 2), "timeout");

        Modulate = Colors.White;
    }
}
