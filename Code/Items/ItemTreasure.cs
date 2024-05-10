using System;
using Godot;

namespace Items
{
    public partial class ItemTreasure : Item
    {
        [Export]
        private int _points = 16;

        public override void Use()
        {
            Game.Points += _points;
            base.Use();

            GD.Print("Сокровище!");
        }
    }
}
