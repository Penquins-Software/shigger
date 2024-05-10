using System;
using System.Collections.Generic;
using Godot;

namespace Biomes
{
    public partial class Biome04Cheese : Biome
    {
        public static PackedScene Back = ResourceLoader.Load<PackedScene>("res://Scenes/chunks/earth_background.tscn");
        public static PackedScene[] BaseChunks = new PackedScene[]
        {
            ResourceLoader.Load<PackedScene>("res://Scenes/chunks/cheese_base_chunk_01.tscn"),
            ResourceLoader.Load<PackedScene>("res://Scenes/chunks/cheese_base_chunk_02.tscn"),
            ResourceLoader.Load<PackedScene>("res://Scenes/chunks/cheese_base_chunk_03.tscn"),
            ResourceLoader.Load<PackedScene>("res://Scenes/chunks/cheese_base_chunk_04.tscn"),
        };
        public static PackedScene SolidChunk = ResourceLoader.Load<PackedScene>("res://Scenes/chunks/cheese_solid_chunk.tscn");

        public Biome04Cheese()
        {
            _type = BiomeType.Cheese;
            _width = 9;
            _chunkPossibility = 0.85;
            _solidChunkPossibility = 0.35;
            _itemPossibility = 0.04;

            _leftExtremePoint = 0;
            _rightExtremePoint = 8;

            _monsterSpeed = 1;
        }

        public override PackedScene GetBack()
        {
            return Back;
        }

        public override PackedScene GetBaseChunk()
        {
            return BaseChunks[GD.RandRange(0, BaseChunks.Length - 1)];
        }

        public override PackedScene GetSolidChunk()
        {
            return SolidChunk;
        }
    }
}
