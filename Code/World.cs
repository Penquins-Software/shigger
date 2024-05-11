using Biomes;
using Godot;
using System;
using System.Collections.Generic;
using System.Linq;

public partial class World : Node2D
{
    private const int LEVEL_START = 32;
    private const int LEVEL_EARTH = 64;
    private const int LEVEL_MAGMA = 128;
    private const int LEVEL_CHEESE = 512;
    private const int LEVEL_BACK_EARTH = 1024;
    private const int LEVEL_WATER = 1025;
    private const int LEVEL_SAND = 1026;
    private const int LEVEL_SKY = 1280;
    private const int LEVEL_ORBIT = 1536;
    private const int LEVEL_SOLAR = 1664;
    private const int LEVEL_GALACTIC = 1920;

    public const int LEFT_POINT = 0;
    public const int MIDDLE_POINT = 4;
    public const int RIGHT_POINT = 8;

    [Export]
    private Game _game;
    [Export]
    private Player _player;
    [Export]
    private Monster _monster;
    [Export]
    private MusicPlayer _musicPlayer;

    private List<Vector2I> _path;
    private Dictionary<Vector2I, bool> _back;

    private List<Biome> _biomes;

    private Dictionary<Vector2I, GroundChunk> _chunks;

    private bool _isMagma = false;
    private bool _isCheese = false;

    private bool _is5 = false;
    private bool _is7 = false;
    private bool _is9 = false;


    private int _pathLevel => _path.Last().Y;


	public override void _Ready()
	{
        CreateWorld();

        _player.MoveLeft += () => MoveLeft();
        _player.MoveRight += () => MoveRight();
        _player.Dig += () => Dig();
    }

    private void CreateWorld() 
	{
        GD.Randomize();

        _player.Place(new Vector2I(MIDDLE_POINT, 0));
        _monster.PlaceMonster(new Vector2I(MIDDLE_POINT, -16));
        _musicPlayer.Play75BPM();
        _musicPlayer.Play75BPM();
        _player.SetBPMInSeconds(Constantns.BPM_75);

        _path = new List<Vector2I>
        {
			// Начальные точки.
            new Vector2I(MIDDLE_POINT, 0),
            new Vector2I(MIDDLE_POINT, 1),
            new Vector2I(MIDDLE_POINT, 2),
            new Vector2I(MIDDLE_POINT, 3),
        };
        _back = new Dictionary<Vector2I, bool>();
        _chunks = new Dictionary<Vector2I, GroundChunk>();

        for (int y = -16; y < 0; y++)
        {
            for (int x = MIDDLE_POINT - 1; x < MIDDLE_POINT + 2; x++)
            {
                var pos = new Vector2I(x, y);
                AddBack(pos, Biome01Start.Back.Instantiate() as Node2D);
                if (x != MIDDLE_POINT)
                {
                    AddChunk(pos, Biome01Start.BaseChunks[GD.RandRange(0, 3)].Instantiate() as Node2D);
                }
            }
        }
        for (int y = 0; y < 3; y++) 
        {
            for (int x = MIDDLE_POINT - 1; x < MIDDLE_POINT + 2; x++)
            {
                var pos = new Vector2I(x, y);
                AddBack(pos, Biome01Start.Back.Instantiate() as Node2D);
                if (y != 0 || x != MIDDLE_POINT)
                {
                    AddChunk(pos, Biome01Start.BaseChunks[GD.RandRange(0, 3)].Instantiate() as Node2D);
                }
            }
        }

        var background = Biome01Start.Background.Instantiate() as BiomeBackground;
        background.Place(new Vector2(MIDDLE_POINT, -30), _game, _player);
        AddChild(background);

        _biomes = new List<Biome>();

        ContinuePath();
    }

    private void ContinuePath() 
    {
        int current_level = _pathLevel;

        Biome biome = null;

        if (current_level < LEVEL_START)
        {
            biome = new Biome01Start();
            biome.Generate(_path, 29);
        }
        else if (current_level < LEVEL_EARTH)
        {
            biome = new Biome02Earth();
            biome.Generate(_path);
        }
        else if (current_level < LEVEL_MAGMA)
        {
            biome = new Biome03Magma();
            biome.Generate(_path);
        }
        else if (current_level < LEVEL_CHEESE)
        {
            biome = new Biome04Cheese();
            biome.Generate(_path);
        }
        else if (current_level < LEVEL_BACK_EARTH)
        {
            biome = new Biome04Cheese();
            biome.Generate(_path);
        }
        else
        {
            biome = new Biome04Cheese();
            biome.Generate(_path);
            GD.Print("Сырный биом!");
        }

        if (biome != null)
        {
            _biomes.Add(biome);
            PlaceChunks(biome);
            PlaceItems(biome);
            CreateBackground(biome);
        }
    }

    private void PlaceChunks(Biome biome) 
    {
        foreach (var back_position in biome.BackPositions)
        {
            var back = biome.GetBack().Instantiate() as Node2D;
            AddBack(back_position, back);
        }

        foreach (var chunk_position in biome.BaseChunkPositions) 
        {
            var chunk = biome.GetBaseChunk().Instantiate() as Node2D;
            AddChunk(chunk_position, chunk);
        }
        foreach (var chunk_position in biome.SolidChunkPositions)
        {
            var chunk = biome.GetSolidChunk().Instantiate() as Node2D;
            AddChunk(chunk_position, chunk);
        }
    }

    private void AddBack(Vector2I position, Node2D back)
    {
        _back.Add(position, true);
        back.Position = position * Constantns.FACTOR;
        AddChild(back);
    }

    private void AddChunk(Vector2I position, Node2D chunk)
    {
        chunk.Position = position * Constantns.FACTOR;
        AddChild(chunk);
        _chunks[position] = (chunk as GroundChunk);
    }

    private void PlaceItems(Biome biome)
    {
        foreach (var position in biome.ItemPositions)
        {
            var item = Item.GetRandomItem();
            item.Position = position * Constantns.FACTOR;
            AddChild(item);
            item.Place(_player, _monster, this);
        }
    }

    private void CreateBackground(Biome biome) 
    {
        var background = biome.GetBackground();
        background.Place(new Vector2(MIDDLE_POINT, biome.StartPoint.Y), _game, _player);
        AddChild(background);
    }

    private void MoveLeft()
    {
        var new_position = _player.WorldPosition - new Vector2I(1, 0);
        if (!_back.ContainsKey(new_position)) 
        {
            return;
        }
        if (_chunks.ContainsKey(new_position))
        {
            // На пути есть блок. Можно попробовать забраться на него.
            var upper_player_position = _player.WorldPosition - new Vector2I(0, 1);
            var upper_chunk_position = new_position - new Vector2I(0, 1);
            if (!_chunks.ContainsKey(upper_player_position) && !_chunks.ContainsKey(upper_chunk_position) && _back.ContainsKey(upper_chunk_position))
            {
                PlacePlayer(upper_chunk_position);
                return;
            }
            else 
            {
                return;
            }
        }
        PlacePlayer(new_position);
    }

    private void MoveRight()
    {
        var new_position = _player.WorldPosition + new Vector2I(1, 0);
        if (!_back.ContainsKey(new_position))
        {
            return;
        }
        if (_chunks.ContainsKey(new_position))
        {
            // На пути есть блок. Можно попробовать забраться на него.
            var upper_player_position = _player.WorldPosition - new Vector2I(0, 1);
            var upper_chunk_position = new_position - new Vector2I(0, 1);
            if (!_chunks.ContainsKey(upper_player_position) && !_chunks.ContainsKey(upper_chunk_position) && _back.ContainsKey(upper_chunk_position))
            {
                PlacePlayer(upper_chunk_position);
                return;
            }
            else
            {
                return;
            }
        }
        PlacePlayer(new_position);
    }

    private void Dig()
    {
        var new_position = _player.WorldPosition + new Vector2I(0, 1);
        if (TryHitChunkByPosition(new_position))
        {
            _player.PlayDigAnim();

            WideShovel(new_position);
            SidewaysShovel(new_position);
            Drill(new_position);
        }
        else
        {
            PlacePlayer(new_position);
        }
    }

    private void WideShovel(Vector2I position) 
    {
        if (!Player.WideShovel) 
        {
            return;
        }

        TryHitChunkByPosition(position - new Vector2I(1, 0));
        TryHitChunkByPosition(position + new Vector2I(1, 0));
    }

    private void SidewaysShovel(Vector2I position)
    {
        if (!Player.SidewaysShovel)
        {
            return;
        }

        TryHitChunkByPosition(position + new Vector2I(-1, -1));
        TryHitChunkByPosition(position + new Vector2I(1, -1));
    }

    private void Drill(Vector2I position)
    {
        if (!Player.Drill)
        {
            return;
        }

        TryHitChunkByPosition(position + new Vector2I(0, 1));
    }

    private bool TryHitChunkByPosition(Vector2I position)
    {
        GroundChunk chunk;
        if (_chunks.TryGetValue(position, out chunk))
        {
            if (chunk.Dig(_player))
            {
                _chunks.Remove(position);
                Game.Instance.AddPoints(chunk.Points);
                chunk.Destroy(Game.CurrentBPMInSeconds1_2);
            }

            return true;
        }

        return false;
    }

    private void PlacePlayer(Vector2I position)
    {
        var lower_position = position + new Vector2I(0, 1);
        //// Есть ли на что наступить?
        //if (!_chunks.ContainsKey(lower_position)) 
        //{
        //    // Если нет, то игрок проваливается на одну клетку вниз.
        //    position = lower_position;
        //}

        _player.Place(position);
        //_playerPosition = position;
        //_player.Position = position * Constantns.FACTOR;

        if (_player.WorldPosition.Y + 64 > _pathLevel) 
        {
            ContinuePath();
        }
    }

    public void Bit() 
    {
        CheckMonsterPosition();
        CheckPlayerPosition();
        //GD.Print($"Level: {_playerPosition.Y}");
    }

    private void CheckPlayerPosition()
    {
        if (!_isMagma && _player.WorldPosition.Y > LEVEL_EARTH - 2)
        {
            _isMagma = true;
            _player.DoABarrelRoll();
            _player.SetBPMInSeconds(Constantns.BPM_100);
            _musicPlayer.Play100BPM();
            _monster.Play100();
            //_player.RotateCamera90();
        }
        else if (!_isCheese && _player.WorldPosition.Y > LEVEL_MAGMA - 2)
        {
            _isCheese = true;
            _player.DoABarrelRoll();
            _player.SetBPMInSeconds(Constantns.BPM_120);
            _musicPlayer.Play120BPM();
            _monster.Play120();
            //_player.RotateCamera180();
        }
    }

    private void CheckMonsterPosition() 
    {
        if (_monster.WorldPosition.Y + 14 < _player.WorldPosition.Y) 
        {
            _monster.PlaceMonster(new Vector2I(_monster.WorldPosition.X, _player.WorldPosition.Y - 14));
        }

        if (!_is5 && _monster.WorldPosition.Y > LEVEL_START - 4) 
        {
            _is5 = true;
            _monster.SetSize(5);
        }
        else if (!_is7 && _monster.WorldPosition.Y > LEVEL_EARTH - 4)
        {
            _is7 = true;
            _monster.SetSize(7);
        }
        else if (!_is9 && _monster.WorldPosition.Y > LEVEL_MAGMA - 4)
        {
            _is9 = true;
            _monster.SetSize(9);
        }
    }

    public void Explode(Vector2 game_position) 
    {
        var world_position = (Vector2I)(game_position / Constantns.FACTOR);
        GD.Print(world_position);

        int points = 0;
        for (int index = -2; index < 3; index++)
        {
            var position = world_position + new Vector2I(index, 0);
            if (_chunks.ContainsKey(position))
            {
                points += DestroyChunkByPosition(position, true);
            }
            position = world_position + new Vector2I(0, index);
            if (_chunks.ContainsKey(position))
            {
                points += DestroyChunkByPosition(position, true);
            }
        }

        Message.Create(this, _player.Position, $"[color=red]+{points}!", delay: Game.CurrentBPMInSeconds1_2);
    }

    private int DestroyChunkByPosition(Vector2I position, bool explode)
    {
        var chunk = _chunks[position];
        _chunks.Remove(position);
        var points = Game.Instance.AddPoints(chunk.Points, show_message: false);
        chunk.Destroy(Game.CurrentBPMInSeconds1_2, explode);
        return points;
    }
}
