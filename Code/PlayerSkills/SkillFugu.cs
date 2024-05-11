using System;
using Godot;

namespace Items
{
    public partial class SkillFugu : SkillCard
    {
        public override void Accept()
        {
            Player.Fugu = true;
            base.Accept();
        }
    }
}
