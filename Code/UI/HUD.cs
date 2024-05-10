using Godot;
using System;

public partial class HUD : CanvasLayer
{
    [Export]
    private Button _pauseButton;


    public Button PauseButton => _pauseButton;
}
