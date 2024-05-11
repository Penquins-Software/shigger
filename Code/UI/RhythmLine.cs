using Godot;
using System;

public partial class RhythmLine : Line2D
{
    [Export]
    private Area2D _area2D;

    private Game _game;

    private Vector2 _direction;
    private Vector2 _destination;

    private int _bits = 3;
    private float _distance;
    private float _partDistance;
    private double _partTime;

    public void Set(Game game, Vector2 position, Vector2 direction, Vector2 destination) 
    {
        _game = game;

        Position = position;
        _direction = direction;
        _destination = destination;

        _distance = Mathf.Abs(position.X - destination.X);
        _partDistance = _distance / _bits;
        _partTime = _partDistance / Game.CurrentBPMInSeconds;

        _game.BitChanged += () => QueueFree();

        _area2D.AreaEntered += (area) => 
        {
            if (area is RhythmArea) 
            {
                QueueFree();
            }
        };
    }

	public override void _Process(double delta)
	{
        Position += _direction * (float)(delta * _partTime);
	}
}
