using Godot;
using Settings.Data;
using System;

namespace Settings 
{
    public partial class Config : Node
    {
        private static readonly string PATH_TO_CONFIG = "user://config.ini";

        private static ConfigFile _config = new ConfigFile();

        private static string _playerName = "";

        private static string _locale = OS.GetLocale();

        private static ScreenMode _screenMode = ScreenMode.Windowed;

        private static int _masterVolume = 50;
        private static int _sfxVolume = 50;
        private static int _musicVolume = 50;

        private static bool _cameraShaking = true;
        private static bool _turorial = false;


        public static string PlayerName
        {
            get
            {
                return _playerName;
            }
            set
            {
                _playerName = value;

                GD.Print($"Имя игрока: {_playerName}");
            }
        }

        public static ScreenMode ScreenMode 
        {
            get 
            {
                return _screenMode;
            }
            set 
            {
                _screenMode = value;
                switch (value)
                {
                    case ScreenMode.Windowed:
                        DisplayServer.WindowSetMode(DisplayServer.WindowMode.Windowed);
                        break;
                    case ScreenMode.Fullscreen:
                        DisplayServer.WindowSetMode(DisplayServer.WindowMode.Fullscreen);
                        break;
                }

                GD.Print($"Режим экрана: {_screenMode}");
            }
        }

        public static string Locale 
        {
            get 
            {
                return _locale;
            }
            set 
            {
                _locale = value;
                TranslationServer.SetLocale(value);

                GD.Print($"Установленная локаль: {_locale}");
            }
        }

        public static int MasterVolume
        {
            get 
            {
                return _masterVolume;
            }
            set 
            {
                SetAudioVolume(AudioBus.Master, value);
            }
        }

        public static int SFXVolume
        {
            get
            {
                return _sfxVolume;
            }
            set
            {
                SetAudioVolume(AudioBus.SFX, value);
            }
        }

        public static int MusicVolume
        {
            get
            {
                return _musicVolume;
            }
            set
            {
                SetAudioVolume(AudioBus.Music, value);
            }
        }

        public static bool CameraShaking 
        {
            get 
            {
                return _cameraShaking;
            }
            set 
            {
                _cameraShaking = value;
            }
        }

        public static bool Tutorial
        {
            get
            {
                return _turorial;
            }
            set
            {
                _turorial = value;
            }
        }


        public override void _EnterTree()
        {
            Load();
        }

        public override void _ExitTree()
        {
            Save();
        }

        private static void Save()
        {
            _config.SetValue("profile", "player_name", _playerName);

            _config.SetValue("general_settings", "locale", _locale);

            _config.SetValue("screen_settings", "mode", (int)_screenMode);

            _config.SetValue("audio_settings", "master_volume", _masterVolume);
            _config.SetValue("audio_settings", "sfx_volume", _sfxVolume);
            _config.SetValue("audio_settings", "music_volume", _musicVolume);

            _config.SetValue("game_settings", "shaking", _cameraShaking);
            _config.SetValue("game_settings", "turorial", _turorial);

            _config.Save(PATH_TO_CONFIG);
        }

        private static void Load()
        {
            var error = _config.Load(PATH_TO_CONFIG);
            if (error == Error.Ok)
            {
                GD.Print("Configuration file loaded successfully!");

                PlayerName = _config.GetValue("profile", "player_name").AsString();

                Locale = _config.GetValue("general_settings", "locale").AsString();

                ScreenMode = (ScreenMode)_config.GetValue("screen_settings", "mode").AsInt32();

                MasterVolume = _config.GetValue("audio_settings", "master_volume").AsInt32();
                SFXVolume = _config.GetValue("audio_settings", "sfx_volume").AsInt32();
                MusicVolume = _config.GetValue("audio_settings", "music_volume").AsInt32();

                CameraShaking = _config.GetValue("game_settings", "shaking").AsBool();
                Tutorial = _config.GetValue("game_settings", "turorial").AsBool();
            }
            else
            {
                GD.Print($"Failed to read configuration file: {error}");
            }
        }

        public static void SetAudioVolume(AudioBus bus, float value)
        {
            float db = Mathf.LinearToDb(value / 100.0f);
            AudioServer.SetBusVolumeDb(AudioServer.GetBusIndex(bus.ToString()), db);

            switch (bus) 
            {
                case AudioBus.Master:
                    _masterVolume = (int)value;
                    break;
                case AudioBus.SFX:
                    _sfxVolume = (int)value;
                    break;
                case AudioBus.Music:
                    _musicVolume = (int)value;
                    break;
            }

            GD.Print($"Громкость шины {bus} установлена на {db} db.");
        }

        public static int GetAudioVolume(AudioBus bus)
        {
            return bus switch
            {
                AudioBus.Master => _masterVolume,
                AudioBus.SFX => _sfxVolume,
                AudioBus.Music => _musicVolume,
                _ => _musicVolume,
            };
        }
    }
}
