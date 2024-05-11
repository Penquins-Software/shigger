using System;
using Godot;

namespace Items
{
    public partial class SkillWideShovel : SkillCard
    {
        public override void Accept()
        {
            Player.WideShovel = true;
            base.Accept();
        }
    }
}
