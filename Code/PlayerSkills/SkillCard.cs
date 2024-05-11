using System;
using Godot;

namespace Items
{
    public partial class SkillCard : Control
    {
        [Signal]
        public delegate void SelectedEventHandler(SkillCard skill_card);

        [Export(PropertyHint.MultilineText)]
        protected string _title;
        [Export(PropertyHint.MultilineText)]
        protected string _description;

        public override void _Ready()
        {
            MouseEntered += () => 
            {
                Modulate = new Color(0.5f, 0.5f, 0.5f);
            };
            MouseExited += () =>
            {
                Modulate = Colors.White;
            };
            GuiInput += (@event) =>
            {
                if (@event.IsActionPressed("mouse_left")) 
                {
                    Accept();
                }
            };
        }

        public virtual void Accept()
        {
            EmitSignal(SignalName.Selected, this);
        }
    }
}
