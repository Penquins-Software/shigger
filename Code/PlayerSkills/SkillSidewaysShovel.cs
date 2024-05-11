using System;
using Godot;

namespace Items
{
    public partial class SkillSidewaysShovel : SkillCard
    {
        public override void Accept()
        {
            Player.SidewaysShovel = true;
            base.Accept();
        }
    }
}
