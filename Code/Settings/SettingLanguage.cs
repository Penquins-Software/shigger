using Godot;
using Settings;
using System;

public partial class SettingLanguage : Control
{
    private string[] _locales;

    [Export] private MenuButton _menuButton;

    public override void _Ready()
    {
        _locales = TranslationServer.GetLoadedLocales();

        if (_locales.Length < 2) 
        {
            Hide();
            return;
        }

        for (int index = 0; index < _locales.Length; index++)
        {
            string l = _locales[index];
            _menuButton.GetPopup().AddItem(TranslationServer.GetLocaleName(l));
        }

        _menuButton.Text = TranslationServer.GetLocaleName(Config.Locale);

        _menuButton.GetPopup().IndexPressed += SetLanguage;
    }

    private void SetLanguage(long id)
    {
        _menuButton.Text = _menuButton.GetPopup().GetItemText((int)id);
        TranslationServer.SetLocale(_locales[id]);
        Config.Locale = _locales[id];
    }

}
