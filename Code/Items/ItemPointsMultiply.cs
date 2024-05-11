using System;
using Godot;

namespace Items
{
    public partial class ItemPointsMultiply : Item
    {
        [Export]
        private int _multiplier = 2;
        [Export]
        private int _bits = 16;

        public override void Use()
        {
            Game.Instance.SetPointsMultiplier(_multiplier, _bits);
            Message.Create(_world, _player.Position, $"[color=green]Множитель очков!");
            base.Use();
        }
    }
}
