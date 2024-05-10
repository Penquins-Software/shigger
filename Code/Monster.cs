using Godot;
using System;

public partial class Monster : Node2D
{
    private const int MIN_BITS_TO_ATTACK = 6;
    private const int MAX_BITS_TO_ATTACK = 12;

    private const int ATTACK_SPEED = 1;
    private const int MIN_DEFAULT_SPEED = 2;
    private const int MAX_DEDAULT_SPEED = 4;

    private const double MAX_ATTACK_POSSIBILITY = 0.1;
    private double _attackPossibility = 0.03;

    private int _attackBits = 0;
    private bool _attack = false;

    private int _stopBits = 0;
    private bool _stop = false;

    private int _bitsPerMove = 3;
    private int _currentBits = 0;

    private Vector2I _worldPosition;

    public Vector2I WorldPosition => _worldPosition;

    public int BitsPerMove 
    {
        set 
        {
            _currentBits = 0;
            _bitsPerMove = value;
            GD.Print($"Monster speed: {value}");
        }
    }

    [Export]
    private AnimationPlayer _animationPlayer;

    public void PlaceMonster(Vector2I world_position)
    {
        _worldPosition = world_position;
        Position = _worldPosition * Constantns.FACTOR;
    }

    public void Move()
    {
        if (_stop) 
        {
            _stopBits--;
            if (_stopBits <= 0)
            {
                EndStop();
            }
            return;
        }

        _currentBits++;
        if (_currentBits >= _bitsPerMove) 
        {
            _currentBits = 0;
            _worldPosition = _worldPosition + new Vector2I(0, 1);
            Position = _worldPosition * Constantns.FACTOR;
        }

        if (_attack)
        {
            _attackBits--;
            if (_attackBits <= 0)
            {
                EndAttack();
            }
        }
        else 
        {
            if (GD.RandRange(0.0, 1.0) < _attackPossibility) 
            {
                StartAttack();
            }
        }
    }

    public void StartAttack() 
    {
        _attack = true;
        _attackBits = GD.RandRange(MIN_BITS_TO_ATTACK, MAX_BITS_TO_ATTACK);
        BitsPerMove = ATTACK_SPEED;
        GD.Print($"Start attack! Time: {_attackBits}.");

        if (_attackPossibility < MAX_ATTACK_POSSIBILITY)
        {
            _attackPossibility += 0.005;
            GD.Print($"Next attack possibility: {_attackPossibility}.");
        }
    }

    public void EndAttack()
    {
        _attack = false;
        _attackBits = 0;
        BitsPerMove = GD.RandRange(MIN_DEFAULT_SPEED, MAX_DEDAULT_SPEED);
        GD.Print("End attack.");
    }

    public void Stop(int bits)
    {
        GD.Print("Monster stop.");
        _stop = true;
        _stopBits = bits;
        EndAttack();
    }

    public void EndStop()
    {
        _stop = false;
        _stopBits = 0;
    }

    public void SetSize(int width) 
    {
        GD.Print("Play" + width);
        if (width == 3) 
        {
            _animationPlayer.Play("3");
        }
        else if (width == 5)
        {
            _animationPlayer.Play("5");
        }
        else if (width == 7)
        {
            _animationPlayer.Play("7");
        }
        else if (width == 9)
        {
            _animationPlayer.Play("9");
        }
    }
}
