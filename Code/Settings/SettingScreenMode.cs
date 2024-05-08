using Godot;
using Settings;
using Settings.Data;
using System;

public partial class SettingScreenMode : MenuButton
{
    public override void _Ready()
    {
        Text = GetPopup().GetItemText((int)Config.ScreenMode);
        GetPopup().IndexPressed += SetScreenMode;

        if (OS.HasFeature("mobile"))
        {
            GetParent<Control>().Hide();
        }
    }

    private void SetScreenMode(long index)
    {
        Config.ScreenMode = (ScreenMode)index;
        Text = GetPopup().GetItemText((int)index);
    }
}
