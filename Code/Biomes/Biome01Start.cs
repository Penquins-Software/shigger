using System;
using System.Collections.Generic;
using Godot;

namespace Biomes
{
    public partial class Biome01Start : Biome
    {
        public static PackedScene Back = ResourceLoader.Load<PackedScene>("res://Scenes/chunks/earth_background.tscn");
        public static PackedScene[] BaseChunks = new PackedScene[] 
        {
            ResourceLoader.Load<PackedScene>("res://Scenes/chunks/earth_base_chunk_01.tscn"),
            ResourceLoader.Load<PackedScene>("res://Scenes/chunks/earth_base_chunk_02.tscn"),
            ResourceLoader.Load<PackedScene>("res://Scenes/chunks/earth_base_chunk_03.tscn"),
            ResourceLoader.Load<PackedScene>("res://Scenes/chunks/earth_base_chunk_04.tscn"),
        };
        public static PackedScene SolidChunk = ResourceLoader.Load<PackedScene>("res://Scenes/chunks/earth_solid_chunk.tscn");

        public static PackedScene Background = ResourceLoader.Load<PackedScene>("res://Scenes/biomes/earth_background.tscn");

        public Biome01Start()
        {
            _type = BiomeType.Start;
            _width = 3;
            _chunkPossibility = 0.75;
            _solidChunkPossibility = 0.1;
            _itemPossibility = 0.02;

            _leftExtremePoint = 3;
            _rightExtremePoint = 5;

            _monsterSpeed = 4;
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

        public override BiomeBackground GetBackground() 
        {
            return Background.Instantiate() as BiomeBackground;
        }
    }
}
