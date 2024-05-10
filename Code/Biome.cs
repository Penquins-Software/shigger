using Godot;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

public partial class Biome
{
    protected BiomeType _type;
    protected int _width;
    protected double _chunkPossibility = 0.5;
    protected double _solidChunkPossibility = 0.1;
    protected double _itemPossibility = 0.03;

    protected int _startIndex;
    protected Vector2I _startPoint;
    protected Vector2I _lastPoint;
    protected Vector2I _prevPoint;
    protected int _leftExtremePoint;
    protected int _rightExtremePoint;

    protected int _monsterSpeed = 1;

    public List<Vector2I> BackPositions = new List<Vector2I>();
    public List<Vector2I> BaseChunkPositions = new List<Vector2I>();
    public List<Vector2I> SolidChunkPositions = new List<Vector2I>();
    public List<Vector2I> ItemPositions = new List<Vector2I>();

    public BiomeType Type => _type;
    public int Width => _width;

    public int MonsterSpeed => _monsterSpeed;


    public virtual void Generate(List<Vector2I> path, int depth = 32) 
    {
        _startPoint = path.Last();
        _startIndex = path.Count - 1;

        CreatePath(path, depth);
        CreateChunks(path, depth);
    }

    protected virtual void CreatePath(List<Vector2I> path, int depth)
    {
        _lastPoint = _startPoint;

        // Генерация пути.
        while (depth > 0)
        {
            var new_point = GetNextPoint();
            if (new_point.Y > _lastPoint.Y)
            {
                depth--;
            }
            _prevPoint = _lastPoint;
            _lastPoint = new_point;

            path.Add(_lastPoint);
        }
    }

    protected virtual void CreateChunks(List<Vector2I> path, int depth) 
    {
        for (int y = _startPoint.Y; y < _startPoint.Y + depth; y++) 
        {
            for (int x = _leftExtremePoint; x < _rightExtremePoint + 1; x++) 
            {
                BackPositions.Add(new Vector2I(x, y));

                // Размещение предмета.
                if (GD.RandRange(0.0, 1.0) < _itemPossibility) 
                {
                    //GD.Print($"Add item: {x}, {y}");
                    ItemPositions.Add(new Vector2I(x, y));
                }
                // Размещение блока.
                if (GD.RandRange(0.0, 1.0) < _chunkPossibility)
                {
                    var point = new Vector2I(x, y);
                    if (path.IndexOf(point, _startIndex) > -1) // Если выбранная точка находится на пути...
                    {
                        // ...Нужно убедиться, что сверху есть точка пути.
                        var top_point = new Vector2I(x, y - 1);
                        if (path.IndexOf(top_point) == -1)
                        {
                            // Если точки нет, продолжаем цикл.
                            continue;
                        }
                    }
                    if (GD.RandRange(0.0, 1.0) < _solidChunkPossibility)
                    {
                        SolidChunkPositions.Add(new Vector2I(x, y));
                    }
                    else
                    {
                        BaseChunkPositions.Add(new Vector2I(x, y));
                    }
                }
            }
        }
    }

    protected virtual Vector2I GetNextPoint()
    {
        bool left = (_lastPoint.X > _leftExtremePoint) && (_prevPoint.X != _lastPoint.X - 1);
        bool right = (_lastPoint.X < _rightExtremePoint) && (_prevPoint.X != _lastPoint.X + 1);
        bool down = !left && !right; // Если нельзя влево или вправо, то сразу вниз.

        var new_point = new Vector2I();

        // Выбор направления: 0 - вниз, 1 - в сторону.
        uint direction = GD.Randi() % 9;
        if (direction < 5 || down) 
        {
            new_point.X = _lastPoint.X;
            new_point.Y = _lastPoint.Y + 1;
        }
        else 
        {
            direction = GD.Randi() % 2;
            if (direction == 0 && left) // Влево
            {
                new_point.X = _lastPoint.X - 1;
                new_point.Y = _lastPoint.Y;
            }
            else if (direction == 1 && right) // Вправо
            {
                new_point.X = _lastPoint.X + 1;
                new_point.Y = _lastPoint.Y;
            }
            else
            {
                new_point.X = _lastPoint.X;
                new_point.Y = _lastPoint.Y + 1;
            }
        }

        return new_point;
    }

    public virtual PackedScene GetBack()
    {
        return null;
    }

    public virtual PackedScene GetBaseChunk() 
    {
        return null;
    }

    public virtual PackedScene GetSolidChunk()
    {
        return null;
    }
}
