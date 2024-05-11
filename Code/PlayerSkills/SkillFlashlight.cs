using System;
using Godot;

namespace Items
{
    public partial class SkillFlashlight : SkillCard
    {
        public override void Accept()
        {
            Game.Instance.Player.GetFlashlight();
            base.Accept();
        }
    }
}
