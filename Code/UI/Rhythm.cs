using Godot;
using System;

public partial class Rhythm : Control
{
    [Export]
    private HUD _hud;
    [Export]
    private TextureRect _textureRect;
    [Export]
    private Control _linesContainer;

    private Texture2D _idleButtonTexture = ResourceLoader.Load<Texture2D>("res://2D/rhythm/2_1.png");
    private Texture2D _pressedButtonTexture = ResourceLoader.Load<Texture2D>("res://2D/rhythm/2_2.png");

    private PackedScene _line = ResourceLoader.Load<PackedScene>("res://Scenes/UI/rhythm_line_2d.tscn");

    private float _distance = 300;
    private Vector2 _center;
    private Vector2 _startLeftPoint;
    private Vector2 _startRightPoint;

    public override void _Ready()
    {
        //_hud.Game.BitChanged += () => QueueFree();

        _center = _textureRect.Position;
        _startLeftPoint = new Vector2(_center.X - _distance, _center.Y);
        _startRightPoint = new Vector2(_center.X + _distance, _center.Y);
    }

    public void BitFull() 
    {
        //var line_1 = _line.Instantiate() as RhythmLine;
        //var line_2 = _line.Instantiate() as RhythmLine;
        
        //line_1.Set(_hud.Game, _startLeftPoint, Vector2.Right, _center);
        //_linesContainer.AddChild(line_1);

        //line_2.Set(_hud.Game, _startRightPoint, Vector2.Left, _center);
        //_linesContainer.AddChild(line_2);
    }

    public void Bit1_5()
    {
        _textureRect.Scale = new Vector2(1, 1);
        _textureRect.Texture = _idleButtonTexture;
    }

    public void Bit1_4()
    {
    }

    public void Bit1_3()
    {
    }

    public void Bit2_3()
    {
    }

    public void Bit3_4()
    {
    }

    public void Bit4_5()
    {
        _textureRect.Scale = new Vector2(1.25f, 1.25f);
    }

    public async void PressedInBit()
    {
        _textureRect.Texture = _pressedButtonTexture;

        await ToSignal(GetTree().CreateTimer(Game.CurrentBPMInSeconds1_2), "timeout");

        _textureRect.Texture = _idleButtonTexture;
    }
}
