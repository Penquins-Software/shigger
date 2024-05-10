using Godot;
using Settings;

public partial class SettingNickname : LineEdit
{
    [Export]
    private Button _confirm;

    public override void _Ready()
    {
        Text = Config.PlayerName;
        _confirm.Pressed += () => SetNickname(Text);
    }

    private void SetNickname(string text)
    {
        if (text == null || text == "" || text == Config.PlayerName) 
        {
            return;
        }

        Config.PlayerName = text;
        LootLockerClient.SetPlayerName(text);
    }
}
