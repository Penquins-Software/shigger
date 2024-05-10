using Biomes;
using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

public partial class World : Node2D
{
    private const int LEVEL_START = 32;
    private const int LEVEL_EARTH = 64;
    private const int LEVEL_MAGMA = 128;
    private const int LEVEL_CHEESE = 256;
    private const int LEVEL_BACK_EARTH = 768;
    private const int LEVEL_WATER = 896;
    private const int LEVEL_SAND = 1024;
    private const int LEVEL_SKY = 1280;
    private const int LEVEL_ORBIT = 1536;
    private const int LEVEL_SOLAR = 1664;
    private const int LEVEL_GALACTIC = 1920;

    public const int LEFT_POINT = 0;
    public const int MIDDLE_POINT = 4;
    public const int RIGHT_POINT = 8;


    [Export]
    private Player _player;
    private Vector2I _playerPosition;
    [Export]
    private Monster _monster;

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

        _playerPosition = new Vector2I(MIDDLE_POINT, 0);
        _player.Position = _playerPosition * Constantns.FACTOR;

        _monster.PlaceMonster(new Vector2I(MIDDLE_POINT, -16));

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
            GD.Print("Предмет!");
        }

    }

    private void MoveLeft()
    {
        var new_position = _playerPosition - new Vector2I(1, 0);
        if (!_back.ContainsKey(new_position)) 
        {
            return;
        }
        if (_chunks.ContainsKey(new_position))
        {
            // На пути есть блок. Можно попробовать забраться на него.
            var upper_position = new_position - new Vector2I(0, 1);
            if (!_chunks.ContainsKey(upper_position) && _back.ContainsKey(upper_position))
            {
                PlacePlayer(upper_position);
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
        var new_position = _playerPosition + new Vector2I(1, 0);
        if (!_back.ContainsKey(new_position))
        {
            return;
        }
        if (_chunks.ContainsKey(new_position))
        {
            // На пути есть блок. Можно попробовать забраться на него.
            var upper_position = new_position - new Vector2I(0, 1);
            if (!_chunks.ContainsKey(upper_position) && _back.ContainsKey(upper_position))
            {
                PlacePlayer(upper_position);
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
        var new_position = _playerPosition + new Vector2I(0, 1);
        GroundChunk chunk;
        if (_chunks.TryGetValue(new_position, out chunk))
        {
            _player.PlayDigAnim();
            if (chunk.Dig())
            {
                _chunks.Remove(new_position);
                Game.Points += chunk.Points;
                chunk.Destroy();
                //PlacePlayer(new_position);
            }
        }
        else
        {
            PlacePlayer(new_position);
        }
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

        _playerPosition = position;
        _player.Position = position * Constantns.FACTOR;

        if (_playerPosition.Y + 64 > _pathLevel) 
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
        if (!_isMagma && _playerPosition.Y > LEVEL_EARTH)
        {
            _isMagma = true;
            _player.RotateCamera90();
        }
        else if (!_isCheese && _playerPosition.Y > LEVEL_CHEESE)
        {
            _isCheese = true;
            _player.RotateCamera180();
        }
    }

    private void CheckMonsterPosition() 
    {
        if (_monster.WorldPosition.Y + 16 < _playerPosition.Y) 
        {
            _monster.PlaceMonster(new Vector2I(_monster.WorldPosition.X, _playerPosition.Y - 16));
            GD.Print("Телепортация монстра!");
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

        for (int index = -2; index < 3; index++)
        {
            var position = world_position + new Vector2I(index, 0);
            if (_chunks.ContainsKey(world_position))
            {
                DestroyChunkByPosition(position);
            }
            position = world_position + new Vector2I(index, 0);
            if (_chunks.ContainsKey(world_position))
            {
                DestroyChunkByPosition(position);
            }
        }
    }

    private void DestroyChunkByPosition(Vector2I position)
    {
        var chunk = _chunks[position];
        _chunks.Remove(position);
        Game.Points += chunk.Points;
        chunk.Destroy();
    }
}
