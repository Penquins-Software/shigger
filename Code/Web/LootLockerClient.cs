using System;
using System.Xml.Linq;
using Godot;

public static class LootLockerClient
{
    private static readonly string PATH_TO_DATA_FILE = "user://LootLocker.data";


    private static string _apiKey = "dev_fb7eb641411a4264ba4d9add7ead7815";
    private static string _leaderboardKey = "22174";
    private static string _oldLeaderboardKey = "20344";
    private static string _sessionToken = "";
    private static string _gameVersion = "0.0.0.1";
    private static bool _developmentMode = true;


    private static bool _gettingLeaderboards = false;
    private static bool _gettingOldLeaderboards = false;
    private static bool _uploadScore = false;


    private static string _playerID = "";
    public static string PlayerID => _playerID;

    private static string _playerScore = "";
    public static string PlayerScore => _playerScore;


    private static LeaderboardData[] _leaderboardData;
    public static LeaderboardData[] LeaderboardData => _leaderboardData;


    private static LeaderboardData[] _oldLeaderboardData;
    public static LeaderboardData[] OldLeaderboardData => _oldLeaderboardData;


    private static LootLockerNodeHandler _nodeHandler;
    public static LootLockerNodeHandler NodeHandler
    {
        get
        {
            return _nodeHandler;
        }
        set
        {
            if (value != null)
            {
                _nodeHandler = value;

                _nodeHandler.AuthHTTP.RequestCompleted += AuthenticationRequestCompleted;
                _nodeHandler.LeaderboardHTTP.RequestCompleted += GetLeaderboardsRequestCompleted;
                _nodeHandler.OldLeaderboardHTTP.RequestCompleted += GetOldLeaderboardsRequestCompleted;
                _nodeHandler.SetNameHTTP.RequestCompleted += SetPlayerNameRequestCompleted;
                _nodeHandler.GetNameHTTP.RequestCompleted += GetPlayerNameRequestCompleted;
                _nodeHandler.SubmitScoreHTTP.RequestCompleted += SubmitScoreRequestCompleted;

                GD.Print($"New web handler registered: {_nodeHandler}");
            }
            else
            {
                _nodeHandler = null;

                _gettingLeaderboards = false;
                _gettingOldLeaderboards = false;
                _uploadScore = false;

                GD.Print($"Web handler is erased.");
            }
        }
    }

    public static bool IsAuthenticated => !string.IsNullOrEmpty(_sessionToken);


    public static Action AuthenticationCompleted;
    public static Action<LeaderboardData[]> GetLeaderboardsCompleted;
    public static Action<LeaderboardData[]> GetOldLeaderboardsCompleted;
    public static Action SetPlayerNameCompleted;
    public static Action<string> GetPlayerNameCompleted;
    public static Action SubmitScoreCompleted;
    public static Action<int> GetScoreCompleted;


    public static void Authentication()
    {
        if (IsAuthenticated)
        {
            GD.Print($"Player is already authorized. Session Token: {_sessionToken}");
            return;
        }

        bool player_session_exists = false;
        string player_identifier = string.Empty;

        var file = FileAccess.Open(PATH_TO_DATA_FILE, FileAccess.ModeFlags.Read);
        if (file != null)
        {
            player_identifier = file.GetAsText();
            file.Close();

            GD.Print($"Player ID: {player_identifier}");
        }

        if (!string.IsNullOrEmpty(player_identifier))
        {
            player_session_exists = true;

            GD.Print("Player session exists.");
        }

        string body;
        if (player_session_exists)
        {
            body = Json.Stringify(new Godot.Collections.Dictionary
            {
                { "game_key", _apiKey },
                { "player_identifier", player_identifier },
                { "game_version", _gameVersion },
                { "development_mode", _developmentMode },
            });
        }
        else
        {
            body = Json.Stringify(new Godot.Collections.Dictionary
            {
                { "game_key", _apiKey },
                { "game_version", _gameVersion },
                { "development_mode", _developmentMode },
            }); ;
        }

        var url = "https://api.lootlocker.io/game/v2/session/guest";
        var headers = new string[] { "Content-Type: application/json" };

        Error error = _nodeHandler.AuthHTTP.Request(url, headers, HttpClient.Method.Post, body);
        ErrorHandler(error);
    }

    private static void AuthenticationRequestCompleted(long result, long responseCode, string[] headers, byte[] body)
    {
        var json = new Json();
        json.Parse(body.GetStringFromUtf8());
        var response = json.Data.AsGodotDictionary();

        var file = FileAccess.Open(PATH_TO_DATA_FILE, FileAccess.ModeFlags.Write);

        GD.Print($"Authentication completed. Player ID: {response["player_id"]}");

        _sessionToken = response["session_token"].ToString();
        _playerID = response["player_id"].ToString();

        file.StoreString(response["player_identifier"].ToString());
        file.Close();

        AuthenticationCompleted?.Invoke();
    }

    public static void GetLeaderboards()
    {
        if (!IsAuthenticated)
        {
            GD.Print($"Player is not authorized.");
            return;
        }

        if (_gettingLeaderboards)
        {
            return;
        }

        _gettingLeaderboards = true;
        GD.Print("Getting leaderboards.");

        var url = $"https://api.lootlocker.io/game/leaderboards/{_leaderboardKey}/list?count=1000";
        var headers = new string[] { "Content-Type: application/json", $"x-session-token: {_sessionToken}" };

        Error error = _nodeHandler.LeaderboardHTTP.Request(url, headers, HttpClient.Method.Get);
        ErrorHandler(error);
    }

    private static void GetLeaderboardsRequestCompleted(long result, long responseCode, string[] headers, byte[] body)
    {
        _gettingLeaderboards = false;

        var json = new Json();
        json.Parse(body.GetStringFromUtf8());
        var response = json.Data.AsGodotDictionary();

        var items = response["items"].AsGodotArray();
        _leaderboardData = new LeaderboardData[items.Count];

        for (int index = 0; index < items.Count; index++)
        {
            var rank = items[index].AsGodotDictionary()["rank"].ToString();
            var player_id = items[index].AsGodotDictionary()["member_id"].ToString();
            var player_name = items[index].AsGodotDictionary()["player"].AsGodotDictionary()["name"].ToString();
            var score = items[index].AsGodotDictionary()["score"].ToString();

            if (player_id == _playerID)
            {
                _playerScore = score;
            }

            _leaderboardData[index] = new LeaderboardData(rank, player_id, player_name, score);
        }

        GD.Print($"Leaderboard received. Number of records: {items.Count}");

        GetLeaderboardsCompleted?.Invoke(_leaderboardData);
    }

    public static void GetOldLeaderboards()
    {
        if (!IsAuthenticated)
        {
            GD.Print($"Player is not authorized.");
            return;
        }

        if (_gettingOldLeaderboards)
        {
            return;
        }

        _gettingOldLeaderboards = true;
        GD.Print("Getting old leaderboards.");

        var url = $"https://api.lootlocker.io/game/leaderboards/{_oldLeaderboardKey}/list?count=1000";
        var headers = new string[] { "Content-Type: application/json", $"x-session-token: {_sessionToken}" };

        Error error = _nodeHandler.OldLeaderboardHTTP.Request(url, headers, HttpClient.Method.Get);
        ErrorHandler(error);
    }

    private static void GetOldLeaderboardsRequestCompleted(long result, long responseCode, string[] headers, byte[] body)
    {
        _gettingOldLeaderboards = false;

        var json = new Json();
        json.Parse(body.GetStringFromUtf8());
        var response = json.Data.AsGodotDictionary();

        var items = response["items"].AsGodotArray();
        _oldLeaderboardData = new LeaderboardData[items.Count];

        for (int index = 0; index < items.Count; index++)
        {
            var rank = items[index].AsGodotDictionary()["rank"].ToString();
            var player_id = items[index].AsGodotDictionary()["member_id"].ToString();
            var player_name = items[index].AsGodotDictionary()["player"].AsGodotDictionary()["name"].ToString();
            var score = items[index].AsGodotDictionary()["score"].ToString();

            if (player_id == _playerID)
            {
                _playerScore = score;
            }

            _oldLeaderboardData[index] = new LeaderboardData(rank, player_id, player_name, score);
        }

        GD.Print($"Leaderboard received. Number of records: {items.Count}");

        GetOldLeaderboardsCompleted?.Invoke(_oldLeaderboardData);
    }

    public static void SetPlayerName(string name)
    {
        if (!IsAuthenticated)
        {
            GD.Print($"Player is not authorized.");
            return;
        }

        if (name == null || name == "") 
        {
            return;
        }

        GD.Print("Changing player name.");

        var body = Json.Stringify(new Godot.Collections.Dictionary
            {
                { "name", name },
            });
        var url = "https://api.lootlocker.io/game/player/name";
        var headers = new string[] { "Content-Type: application/json", $"x-session-token: {_sessionToken}" };

        var error = _nodeHandler.SetNameHTTP.Request(url, headers, HttpClient.Method.Patch, body);
        ErrorHandler(error);
    }

    private static void SetPlayerNameRequestCompleted(long result, long responseCode, string[] headers, byte[] body)
    {
        var json = new Json();
        json.Parse(body.GetStringFromUtf8());
        var response = json.Data.AsGodotDictionary();

        GD.Print(response);

        SetPlayerNameCompleted?.Invoke();
    }

    public static void GetPlayerName()
    {
        if (!IsAuthenticated)
        {
            GD.Print($"Player is not authorized.");
            return;
        }

        GD.Print("Getting player name.");

        var url = "https://api.lootlocker.io/game/player/name";
        var headers = new string[] { "Content-Type: application/json", $"x-session-token: {_sessionToken}" };

        var error = _nodeHandler.GetNameHTTP.Request(url, headers, HttpClient.Method.Get);
        ErrorHandler(error);
    }

    private static void GetPlayerNameRequestCompleted(long result, long responseCode, string[] headers, byte[] body)
    {
        var json = new Json();
        json.Parse(body.GetStringFromUtf8());
        var response = json.Data.AsGodotDictionary();

        var name = response["name"].ToString();

        GD.Print(name);
        GD.Print(response);

        GetPlayerNameCompleted?.Invoke(name);
    }

    public static void SubmitScore(int score)
    {
        if (!IsAuthenticated)
        {
            GD.Print($"Player is not authorized.");
            return;
        }

        if (_uploadScore)
        {
            return;
        }

        _uploadScore = true;
        GD.Print("Uploading score.");

        var body = Json.Stringify(new Godot.Collections.Dictionary
        {
                { "score", score },
            });
        var url = $"https://api.lootlocker.io/game/leaderboards/{_leaderboardKey}/submit";
        var headers = new string[] { "Content-Type: application/json", $"x-session-token: {_sessionToken}" };

        var error = _nodeHandler.SubmitScoreHTTP.Request(url, headers, HttpClient.Method.Post, body);
        ErrorHandler(error);
    }

    private static void SubmitScoreRequestCompleted(long result, long responseCode, string[] headers, byte[] body)
    {
        _uploadScore = false;

        var json = new Json();
        json.Parse(body.GetStringFromUtf8());
        var response = json.Data.AsGodotDictionary();

        GD.Print(response);

        SubmitScoreCompleted?.Invoke();
    }

    private static void ErrorHandler(Error error)
    {
        if (error != Error.Ok)
        {
            GD.PushError("An error occurred in the HTTP request.");
        }
    }
}