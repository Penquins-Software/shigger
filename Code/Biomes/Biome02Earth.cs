using System;
using System.Collections.Generic;
using Godot;

namespace Biomes
{
    public partial class Biome02Earth : Biome
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

        public Biome02Earth() 
        {
            _type = BiomeType.Earth;
            _width = 5;
            _chunkPossibility = 0.75;
            _solidChunkPossibility = 0.2;
            _itemPossibility = 0.02;

            _leftExtremePoint = 2;
            _rightExtremePoint = 6;

            _monsterSpeed = 3;
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
