using System;
using System.Collections.Generic;
using Godot;

namespace Biomes
{
    public partial class Biome03Magma : Biome
    {
        public static PackedScene Back = ResourceLoader.Load<PackedScene>("res://Scenes/chunks/earth_background.tscn");
        public static PackedScene[] BaseChunks = new PackedScene[]
        {
            ResourceLoader.Load<PackedScene>("res://Scenes/chunks/magma_base_chunk_01.tscn"),
            ResourceLoader.Load<PackedScene>("res://Scenes/chunks/magma_base_chunk_02.tscn"),
            ResourceLoader.Load<PackedScene>("res://Scenes/chunks/magma_base_chunk_03.tscn"),
            ResourceLoader.Load<PackedScene>("res://Scenes/chunks/magma_base_chunk_04.tscn"),
        };
        public static PackedScene SolidChunk = ResourceLoader.Load<PackedScene>("res://Scenes/chunks/magma_solid_chunk.tscn");

        public Biome03Magma()
        {
            _type = BiomeType.Magma;
            _width = 7;
            _chunkPossibility = 0.8;
            _solidChunkPossibility = 0.3;
            _itemPossibility = 0.03;

            _leftExtremePoint = 1;
            _rightExtremePoint = 7;

            _monsterSpeed = 2;
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
