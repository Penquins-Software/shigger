using Godot;
using System;

public partial class Menu : Control
{
    [ExportGroup("Containers")]
    [Export] private Control _main;
	[Export] private Control _settings;
    [Export] private Control _authors;

    [ExportGroup("Buttons")]
    [Export] private Button _startButton;
    [Export] private Button _settingsButton;
    [Export] private Button _authorsButton;
    [Export] private Button _exitButton;

    [Export] private Button _returnFromSettingsButton;
    [Export] private Button _returnFromAuthorsButton;

    [ExportGroup("Other")]
    [Export] private ConfirmationDialog _exitConfirmationDialog;


    public override void _Ready()
    {
        _startButton.Pressed += StartGame;

        _settingsButton.Pressed += () => ShowMenuElement(_settings);
        _returnFromSettingsButton.Pressed += () => ShowMainMenu(_settings);

        _authorsButton.Pressed += () => ShowMenuElement(_authors);
        _returnFromAuthorsButton.Pressed += () => ShowMainMenu(_authors);

        _exitButton.Pressed += () => _exitConfirmationDialog.Show();
        _exitConfirmationDialog.Confirmed += () => GetTree().Quit();
    }

    private void ShowMenuElement(Control menu_element)
    {
        _main.Hide();
        menu_element.Show();
    }

    private void ShowMainMenu(Control menu_element)
    {
        _main.Show();
        menu_element.Hide();
    }

    private void StartGame()
    {
    }
}
