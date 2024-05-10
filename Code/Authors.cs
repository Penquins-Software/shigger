using Godot;
using System;

public partial class Authors : VBoxContainer
{
    [Export]
    private RichTextLabel _credits;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _credits.MetaClicked += OpenURL;
    }

    private void OpenURL(Variant variant)
    {
        GD.Print("URL");
        OS.ShellOpen(variant.ToString());
    }
}