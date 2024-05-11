using Godot;
using System;

public partial class BiomeBackground : Node2D
{
    private Vector2I _worldPosition;
    private Game _game;
    private Player _player;

    public void Place(Vector2 world_position, Game game, Player player)
    {
        _worldPosition = (Vector2I)world_position;
        _game = game;
        _player = player;

        Position = world_position * Constantns.FACTOR;

        _game.Bit += CheckPosition;
    }

    public void CheckPosition() 
    {
        if (_player.WorldPosition.Y > _worldPosition.Y + 64)
        {
            _game.Bit -= CheckPosition;
            QueueFree();
        }
    }
}
