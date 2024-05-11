using System;
using Godot;

namespace Items
{
    public partial class SkillDrill : SkillCard
    {
        public override void Accept()
        {
            Player.Drill = true;
            base.Accept();
        }
    }
}
