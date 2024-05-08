using Godot;
using System;

public partial class Intro : Control
{
	[Export(PropertyHint.File)] private string _nextSceneFile;

    [Export] private AnimationPlayer _player;

	public override void _Ready()
	{
        _player.AnimationFinished += (StringName name) => LoadNextScene();
    }

    public override void _Input(InputEvent @event)
    {
        if (@event.IsActionPressed("ui_accept")) 
        {
            LoadNextScene();
        }
    }

    private void LoadNextScene() 
    {
        GetTree().ChangeSceneToFile(_nextSceneFile);
    }
}
