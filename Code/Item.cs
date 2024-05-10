using Godot;
using System;

public partial class Item : Node2D
{
    private static PackedScene[] s_ItemScenes = new PackedScene[]
    {
        ResourceLoader.Load<PackedScene>("res://Scenes/items/StopMonster.tscn"),
        ResourceLoader.Load<PackedScene>("res://Scenes/items/Treasure.tscn"),
        ResourceLoader.Load<PackedScene>("res://Scenes/items/Dynamite.tscn"),
    };

    [Export]
    protected Area2D _area2D;

    protected Player _player;
    protected Monster _monster;
    protected World _world;

    public void Place(Player player, Monster monster, World world) 
    { 
        _player = player;
        _monster = monster;
        _world = world;

        _area2D.AreaEntered += (area) => 
        {
            if (area is PlayerArea)
            {
                Use();
            }
            else if (area is MonsterArea) 
            {
                QueueFree();
            }
        };
    }

    public virtual void Use() 
    {
        QueueFree();
    }

    public static Item GetRandomItem()
    {
        return s_ItemScenes[GD.RandRange(0, s_ItemScenes.Length - 1)].Instantiate() as Item;
    }
}
