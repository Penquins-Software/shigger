using System;
using Godot;

namespace Items
{
    public partial class SkillMultiplier : SkillCard
    {
        public override void Accept()
        {
            Game.GlobalMultiplier = 2;
            base.Accept();
        }
    }
}
