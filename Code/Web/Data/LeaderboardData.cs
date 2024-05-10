public struct LeaderboardData
{
    private string _rank;
    private string _playerID;
    private string _playerName;
    private string _score;

    public string Rank => _rank;
    public string PlayerID => _playerID;
    public string PlayerName
    {
        get
        {
            if (_playerName == "")
            {
                return _playerID;
            }

            return _playerName;
        }
    }
    public string Score => _score;

    public LeaderboardData(string rank, string player_id, string player_name, string score)
    {
        _rank = rank;
        _playerID = player_id;
        _playerName = player_name;
        _score = score;
    }
}