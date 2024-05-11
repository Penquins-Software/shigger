using System;
using Godot;

namespace Items
{
    public partial class SkillMegaShovel : SkillCard
    {
        public override void Accept()
        {
            Player.Damage += 1;
            base.Accept();
        }
    }
}
