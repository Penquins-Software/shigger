using Godot;
using System;
using System.Collections.Generic;

public partial class Item : Node2D
{
    private static PackedScene[] s_ItemScenes = new PackedScene[]
    {
        ResourceLoader.Load<PackedScene>("res://Scenes/items/StopMonster.tscn"),
        ResourceLoader.Load<PackedScene>("res://Scenes/items/Treasure.tscn"),
        ResourceLoader.Load<PackedScene>("res://Scenes/items/Dynamite.tscn"),
        //ResourceLoader.Load<PackedScene>("res://Scenes/items/PointsMultiplier.tscn"),
    };

    public static List<Item> s_Items = new List<Item>();

    [Export]
    protected Area2D _area2D;
    [Export]
    protected Light2D _light2D;

    protected Player _player;
    protected Monster _monster;
    protected World _world;

    public override void _EnterTree()
    {
        s_Items.Add(this);
    }

    public override void _ExitTree()
    {
        s_Items.Remove(this);
    }

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

        if (_light2D != null)
        {
            _light2D.Visible = Player.Flashlight;
        }
    }

    public virtual void Use() 
    {
        QueueFree();
    }

    public static Item GetRandomItem()
    {
        return s_ItemScenes[GD.RandRange(0, s_ItemScenes.Length - 1)].Instantiate() as Item;
    }

    public static void TurnOnLight() 
    {
        foreach(var item in s_Items) 
        {
            item._light2D.Visible = true;
        }
    }

    public static void TurnOffLight()
    {
        foreach (var item in s_Items)
        {
            item._light2D.Visible = false;
        }
    }
}
