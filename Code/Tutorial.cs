using Godot;
using Settings;

public partial class Tutorial : Control
{
	[Export]
	private Button _button;

    [Export(PropertyHint.File, "*.tscn")] private string _gameFile;

    public override void _Ready()
	{
        _button.Pressed += () => 
        {
            Config.Tutorial = true;
            GetTree().CallDeferred("change_scene_to_file", _gameFile);
        };
    }
}
