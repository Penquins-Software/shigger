using Godot;
using System;

public partial class Game : Node2D
{
    private static Game s_Instance;
    public static Game Instance => s_Instance;

    [Signal]
    public delegate void BitEventHandler();
    [Signal]
    public delegate void Bit1_5EventHandler();
    [Signal]
    public delegate void Bit1_4EventHandler();
    [Signal]
    public delegate void Bit1_3EventHandler();
    [Signal]
    public delegate void Bit1_2EventHandler();
    [Signal]
    public delegate void Bit2_3EventHandler();
    [Signal]
    public delegate void Bit3_4EventHandler();
    [Signal]
    public delegate void Bit4_5EventHandler();
    [Signal]
    public delegate void BitChangedEventHandler();

    private double _currentTime = 0.0;

    [Export]
    private HUD _hud;
    [Export]
    private Pause _pause;
    [Export]
    private World _world;
    [Export]
    private Player _player;
    [Export]
    private Monster _monster;

    [Export(PropertyHint.File, "*.tscn")] private string _menuFile;
    [Export(PropertyHint.File, "*.tscn")] private string _endingFile;

    private static int s_Points = 0;
    public static int Points
    {
        get
        {
            return s_Points;
        }
        set
        {
            s_Points = value;
        }
    }

    public static double CurrentBPMInSeconds;
    public static double CurrentBPMInSeconds1_5;
    public static double CurrentBPMInSeconds1_4;
    public static double CurrentBPMInSeconds1_3;
    public static double CurrentBPMInSeconds1_2;
    public static double CurrentBPMInSeconds2_3;
    public static double CurrentBPMInSeconds3_4;
    public static double CurrentBPMInSeconds4_5;

    private int _multiplier = 1;
    //private int _multiplierBits = 0;

    private bool _bit_1_5 = false;
    private bool _bit_1_4 = false;
    private bool _bit_1_3 = false;
    private bool _bit_1_2 = false;
    private bool _bit_2_3 = false;
    private bool _bit_3_4 = false;
    private bool _bit_4_5 = false;

    private bool _firstSkill = false;
    private bool _secondSkill = false;
    private bool _thirdSkill = false;
    private bool _fourthSkill = false;
    private bool _fifthSkill = false;
    private bool _sixSkill = false;

    public Player Player => _player;

    public static int GlobalMultiplier = 1;


    public override void _Ready()
    {
        s_Instance = this;

        Points = 0;
        GlobalMultiplier = 1;
        //SetBPM(Constantns.BPM_75);

        _hud.PauseButton.Pressed += () => Pause();
        _hud.Skills.Selected += () => _world.ProcessMode = ProcessModeEnum.Inherit;
        _pause.ContinueButton.Pressed += () => Continue();
        _pause.ReturnButton.Pressed += () => ToMenu();

        Bit += () => _world.Bit();
        Bit += () => _monster.Move();

        Bit += () => _player.BitFull();
        Bit1_5 += () => _player.Bit1_5();
        Bit1_4 += () => _player.Bit1_4();
        Bit1_3 += () => _player.Bit1_3();
        Bit2_3 += () => _player.Bit2_3();
        Bit3_4 += () => _player.Bit3_4();
        Bit4_5 += () => _player.Bit4_5();

        Bit += () => _hud.Rhythm.BitFull();
        Bit1_5 += () => _hud.Rhythm.Bit1_5();
        Bit1_4 += () => _hud.Rhythm.Bit1_4();
        Bit1_3 += () => _hud.Rhythm.Bit1_3();
        Bit2_3 += () => _hud.Rhythm.Bit2_3();
        Bit3_4 += () => _hud.Rhythm.Bit3_4();
        Bit4_5 += () => _hud.Rhythm.Bit4_5();

        _player.Die += () => EndGame();
        _player.InBit += () => _hud.Rhythm.PressedInBit();

        Item.s_Items.Clear();
    }

    public override void _Process(double delta)
    {
        if (_pause.Visible || _hud.Skills.Visible)
        {
            return;
        }

        _currentTime += delta;

        if (!_bit_1_5 && _currentTime > CurrentBPMInSeconds1_5)
        {
            _bit_1_5 = true;
            EmitSignal(SignalName.Bit1_5);
        }
        if (!_bit_1_4 && _currentTime > CurrentBPMInSeconds1_4)
        {
            _bit_1_4 = true;
            EmitSignal(SignalName.Bit1_4);
        }
        if (!_bit_1_3 && _currentTime > CurrentBPMInSeconds1_3)
        {
            _bit_1_3 = true;
            EmitSignal(SignalName.Bit1_3);
        }
        if (!_bit_1_2 && _currentTime > CurrentBPMInSeconds1_2) 
        {
            _bit_1_2 = true;
            EmitSignal(SignalName.Bit1_2);
        }
        if (!_bit_2_3 && _currentTime > CurrentBPMInSeconds2_3)
        {
            _bit_2_3 = true;
            EmitSignal(SignalName.Bit2_3);
        }
        if (!_bit_3_4 && _currentTime > CurrentBPMInSeconds3_4)
        {
            _bit_3_4 = true;
            EmitSignal(SignalName.Bit3_4);
        }
        if (!_bit_4_5 && _currentTime > CurrentBPMInSeconds4_5)
        {
            _bit_4_5 = true;
            EmitSignal(SignalName.Bit4_5);
        }

        if (_currentTime > CurrentBPMInSeconds)
        {
            _currentTime = _currentTime - CurrentBPMInSeconds;
            EmitSignal(SignalName.Bit);

            _bit_1_5 = false;
            _bit_1_4 = false;
            _bit_1_3 = false;
            _bit_1_2 = false;
            _bit_2_3 = false;
            _bit_3_4 = false;
            _bit_4_5 = false;

            _hud.SetPoints(s_Points, _multiplier, _player.SeriesOfHits);
            SetPointsMultiplier(_player.SeriesOfHits);
            //_hud.Rhythm.SetHits(_player.SeriesOfHits);

            //if (_multiplierBits > 0)
            //{
            //    _multiplierBits--;
            //    if (_multiplierBits <= 0)
            //    {
            //        _multiplier = 1;
            //    }
            //}
        }
    }

    public void Pause()
    {
        _hud.Hide();
        _pause.Show();
        _pause.Result.Text = $"[center]Ваш результат: {Points} очков!";
        _world.ProcessMode = ProcessModeEnum.Disabled;
    }

    public void Continue()
    {
        _hud.Show();
        _pause.Hide();

        if (!_hud.Skills.Visible)
        {
            _world.ProcessMode = ProcessModeEnum.Inherit;
        }
    }

    public void ToMenu()
    {
        LootLockerClient.SubmitScore(Points);
        GetTree().CallDeferred("change_scene_to_file", _menuFile);
    }

    public void EndGame()
    {
        LootLockerClient.SubmitScore(Points);
        GetTree().CallDeferred("change_scene_to_file", _endingFile);
    }

    public int AddPoints(int points, bool delay = true, bool show_message = true)
    {
        int value = points * _multiplier;
        Points += value;
        if (show_message)
        {
            double time_delay = delay ? CurrentBPMInSeconds1_2 : 0.1;
            Message.Create(this, _player.Position, $"[color=gray]+{value}", delay: time_delay);
        }
        CheckForGetSkills();
        return value;
    }

    public void CheckForGetSkills() 
    {
        if (!_firstSkill && Points > 64) 
        {
            _firstSkill = true;
            _hud.Skills.ShowSkills();
            _world.ProcessMode = ProcessModeEnum.Disabled;
        }
        if (!_secondSkill && Points > 512)
        {
            _secondSkill = true;
            _hud.Skills.ShowSkills();
            _world.ProcessMode = ProcessModeEnum.Disabled;
        }
        if (!_thirdSkill && Points > 2048)
        {
            _thirdSkill = true;
            _hud.Skills.ShowSkills();
            _world.ProcessMode = ProcessModeEnum.Disabled;
        }
        if (!_fourthSkill && Points > 8192)
        {
            _fourthSkill = true;
            _hud.Skills.ShowSkills();
            _world.ProcessMode = ProcessModeEnum.Disabled;
        }
        if (!_fifthSkill && Points > 32768)
        {
            _fifthSkill = true;
            _hud.Skills.ShowSkills();
            _world.ProcessMode = ProcessModeEnum.Disabled;
        }
        //if (!_sixSkill && Points > 131072)
        //{
        //    _sixSkill = true;
        //    _hud.Skills.ShowSkills();
        //    _world.ProcessMode = ProcessModeEnum.Disabled;
        //}
    }

    public void SetPointsMultiplier(int value, int bits)
    {
        _multiplier *= value;
        //_multiplierBits = bits;

        _hud.SetPoints(s_Points, _multiplier, _player.SeriesOfHits);
    }

    public void SetPointsMultiplier(int hits)
    {
        if (hits < 15) 
        {
            _multiplier = 1 * GlobalMultiplier;
        }
        if (hits >= 15)
        {
            _multiplier = 2 * GlobalMultiplier;
        }
        if (hits >= 31)
        {
            _multiplier = 4 * GlobalMultiplier;
        }
        if (hits >= 63)
        {
            _multiplier = 8 * GlobalMultiplier;
        }
        if (hits >= 127)
        {
            _multiplier = 16 * GlobalMultiplier;
        }
        if (hits >= 255)
        {
            _multiplier = 32 * GlobalMultiplier;
        }

        _hud.SetPoints(s_Points, _multiplier, _player.SeriesOfHits);
    }

    public void SetBPM(double bpm)
    {
        CurrentBPMInSeconds = bpm;
        CurrentBPMInSeconds1_5 = bpm / 5.0;
        CurrentBPMInSeconds1_4 = bpm / 4.0;
        CurrentBPMInSeconds1_3 = bpm / 3.0;
        CurrentBPMInSeconds1_2 = bpm / 2.0;
        CurrentBPMInSeconds2_3 = bpm * 2.0 / 3.0;
        CurrentBPMInSeconds3_4 = bpm * 3.0 / 4.0;
        CurrentBPMInSeconds4_5 = bpm * 4.0 / 5.0;

        _currentTime = 0;


        EmitSignal(SignalName.BitChanged);
    }
}
