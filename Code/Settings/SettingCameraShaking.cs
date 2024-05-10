using Godot;
using Settings;
using System;

public partial class SettingCameraShaking : CheckBox
{
	public override void _Ready()
	{
		ButtonPressed = Config.CameraShaking;
        Toggled += (bool value) => Config.CameraShaking = value;
	}
}
