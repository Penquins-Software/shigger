using Godot;
using Settings;
using System;
using static System.Net.Mime.MediaTypeNames;

public partial class Menu : Control
{
    [ExportGroup("Containers")]
    [Export] private Control _main;
    [Export] private Leaderboard _leaderboard;
    [Export] private Control _settings;
    [Export] private Control _authors;
    [Export] private Control _nickname;

    [ExportGroup("Buttons")]
    [Export] private Button _startButton;
    [Export] private Button _leaderboardButton;
    [Export] private Button _settingsButton;
    [Export] private Button _authorsButton;
    [Export] private Button _exitButton;

    [Export] private Button _returnFromLeaderboardButton;
    [Export] private Button _returnFromSettingsButton;
    [Export] private Button _returnFromAuthorsButton;

    [Export] private Button _enterNickname;

    [ExportGroup("Other")]
    [Export] private ConfirmationDialog _exitConfirmationDialog;
    [Export] private LineEdit _nicknameEdit;

    [Export] private TextureRect _back_01;
    [Export] private TextureRect _back_02;

    [Export(PropertyHint.File, "*.tscn")] private string _gameSceneFile;


    [Export] private AnimationPlayer _animationPlayer;


    public override void _Ready()
    {
        _startButton.Pressed += StartGame;

        _leaderboardButton.Pressed += () => ShowMenuElement(_leaderboard);
        _returnFromLeaderboardButton.Pressed += () => ShowMainMenu(_leaderboard);

        _settingsButton.Pressed += () => ShowMenuElement(_settings);
        _returnFromSettingsButton.Pressed += () => ShowMainMenu(_settings);

        _authorsButton.Pressed += () => ShowMenuElement(_authors);
        _returnFromAuthorsButton.Pressed += () => ShowMainMenu(_authors);

        _exitButton.Pressed += () => _exitConfirmationDialog.Show();
        _exitConfirmationDialog.Confirmed += () => GetTree().Quit();

        _animationPlayer.Play("Idle");

        _enterNickname.Pressed += () => 
        {
            if (_nicknameEdit.Text == "") 
            {
                return;
            }

            Config.PlayerName = _nicknameEdit.Text;
            LootLockerClient.SetPlayerName(Config.PlayerName);
            StartGame();
        };
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
        if (Config.PlayerName == "") 
        {
            _nickname.Show();
            return;
        }

        GetTree().ChangeSceneToFile(_gameSceneFile);
    }
}
