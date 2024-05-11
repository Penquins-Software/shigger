using Godot;
using Items;
using System;
using System.Collections.Generic;

public partial class Skills : Control
{
    [Signal]
    public delegate void SelectedEventHandler();

    [Export]
	private Control _container;

    private List<SkillCard> _currentSkills = new List<SkillCard>();

	private List<SkillCard> _skillCards = new List<SkillCard>() 
	{
		ResourceLoader.Load<PackedScene>("res://Scenes/skills_cards/Drill.tscn").Instantiate() as SkillCard,
        ResourceLoader.Load<PackedScene>("res://Scenes/skills_cards/Flashlight.tscn").Instantiate() as SkillCard,
        ResourceLoader.Load<PackedScene>("res://Scenes/skills_cards/Fugu.tscn").Instantiate() as SkillCard,
        ResourceLoader.Load<PackedScene>("res://Scenes/skills_cards/MegaShovel.tscn").Instantiate() as SkillCard,
        ResourceLoader.Load<PackedScene>("res://Scenes/skills_cards/SidewaysShovel.tscn").Instantiate() as SkillCard,
        ResourceLoader.Load<PackedScene>("res://Scenes/skills_cards/WideShovel.tscn").Instantiate() as SkillCard,
    };

    public void ShowSkills() 
    {
        Show();

        _currentSkills.Clear();

        foreach (var child in _container.GetChildren()) 
        {
            _container.RemoveChild(child);
        }

        for (int index = 0; index < 2; index++) 
        {
            var skill_card = _skillCards[GD.RandRange(0, _skillCards.Count - 1)];
            _container.AddChild(skill_card);
            _skillCards.Remove(skill_card);
            _currentSkills.Add(skill_card);
            skill_card.Selected += SkillSelected;
        }
    }

    private void SkillSelected(SkillCard skill_card) 
    {
        _currentSkills.Remove(skill_card);
        _skillCards.AddRange(_currentSkills);

        EmitSignal(SignalName.Selected);

        Hide();
    }
}
