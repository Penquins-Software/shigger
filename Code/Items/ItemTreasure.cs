using System;
using Godot;

namespace Items
{
    public partial class ItemTreasure : Item
    {
        [Export]
        private int _points = 32;

        public override void Use()
        {
            var points = Game.Instance.AddPoints(_points, false, false);
            Message.Create(_world, _player.Position, $"[color=gold]Сокровище! +{points}");
            base.Use();
        }
    }
}
