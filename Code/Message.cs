using Godot;
using System;

public partial class Message : RichTextLabel
{
	private double _time = 2.0;
	private double _currentTime = 2.0;
	private static readonly Vector2 _shift = new Vector2(0, -64);

	private static PackedScene _messageScene = ResourceLoader.Load<PackedScene>("res://Scenes/message.tscn");

	private static bool _s_Left = false;

	public override void _Process(double delta)
	{
        _currentTime -= delta;
		if (_currentTime < 0) 
		{
			QueueFree();
			return;
		}

		Position += _shift * (float)delta;

		float alpha = (float)(_currentTime / _time);
		var modulate = Modulate;
		modulate.A = alpha;
		Modulate = modulate;
    }

	public void Show(string text, double time = 2.0) 
	{
		Text = $"[center]{text}";
        _time = time;
        _currentTime = time;


		Vector2 position = Position;
        float degrees = 0;
		if (_s_Left)
		{
            degrees = (float)GD.RandRange(-10.0, -5.0);
            position.X -= (float)GD.RandRange(16.0, 24.0);
        }
		else
        {
            degrees = (float)GD.RandRange(5.0, 10.0);
            position.X += (float)GD.RandRange(16.0, 24.0);
        }
		_s_Left = !_s_Left;

		Position = position;
        RotationDegrees = degrees;
    }

	public static async void Create(Node2D sender, Vector2 position, string text, double time = 2.0, double delay = 0.1) 
	{
        await sender.ToSignal(sender.GetTree().CreateTimer(delay), "timeout");

        var message = _messageScene.Instantiate() as Message;
        sender.AddChild(message);
		position -= message.Size / 2;
		position += new Vector2(32, 16);
        message.Position = position;
        message.Show(text, time);
    }
}
