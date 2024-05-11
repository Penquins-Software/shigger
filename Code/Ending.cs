using Godot;
using System;

public partial class Ending : Node2D
{
    [Export]
    private RichTextLabel _text;
    [Export]
	private Button _returnToMenu;
    [Export]
    private AnimationPlayer _animationPlayer;

    [Export(PropertyHint.File, "*.tscn")] private string _menuSceneFile;

    public override void _Ready()
	{
		_text.Text = $"[center]Вас съели!\n\nВаш результат: {Game.Points} очков.";

        _returnToMenu.Pressed += () => GetTree().CallDeferred("change_scene_to_file", _menuSceneFile);
    }

    public override void _Input(InputEvent @event)
    {
        if (@event.IsActionPressed("ui_accept") || @event.IsActionPressed("mouse_left")) 
        {
            _animationPlayer.Play("RESET");
        }
    }
}
