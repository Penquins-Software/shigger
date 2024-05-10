using System;
using Godot;

namespace Items
{
    public partial class ItemDynamite : Item
    {
        public override void Use()
        {
            _world.Explode(Position);
            base.Use();
        }
    }
}
