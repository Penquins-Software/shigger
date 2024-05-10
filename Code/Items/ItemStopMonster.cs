using System;
using Godot;

namespace Items
{
    public partial class ItemStopMonster : Item
    {
        [Export]
        private int _bits = 8;

        public override void Use()
        {
            _monster.Stop(_bits);
            base.Use();
        }
    }
}
