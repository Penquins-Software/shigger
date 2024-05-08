using Godot;
using Settings;
using Settings.Data;
using System;

public partial class SettingAudioBus : HBoxContainer
{
    [Export] private AudioBus _bus = AudioBus.Master;

    [Export] private HSlider _slider;
    [Export] private SpinBox _spinBox;

    public override void _Ready()
    {
        _slider.Value = Config.GetAudioVolume(_bus);
        _spinBox.Value = _slider.Value;

        _slider.ValueChanged += SliderValueChanged;
        _spinBox.ValueChanged += SpinBoxValueChanged;
    }

    private void SliderValueChanged(double value)
    {
        _spinBox.Value = _slider.Value;
        Config.SetAudioVolume(_bus, (float)value);
    }

    private void SpinBoxValueChanged(double value)
    {
        _slider.Value = _spinBox.Value;
    }
}
