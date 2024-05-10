using Godot;
using System;

public partial class Pause : CanvasLayer
{
    [Export]
    private Button _continueButton;
    [Export]
    private Button _returnButton;
    [Export]
    private RichTextLabel _result;


    public Button ContinueButton => _continueButton;
    public Button ReturnButton => _returnButton;
    public RichTextLabel Result => _result;
}
