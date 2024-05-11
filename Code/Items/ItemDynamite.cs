using System;
using Godot;

namespace Items
{
    public partial class ItemDynamite : Item
    {
        private static AudioStream _sfx = ResourceLoader.Load<AudioStream>("res://audio/sfx/bomb.mp3");

        public override void Use()
        {
            _world.Explode(Position);
            SFXAudioStreamPlayer.Instance.PlaySFX(_sfx);
            Message.Create(_world, _player.Position, "[color=red]ВЗРЫВ!");
            base.Use();
        }
    }
}
