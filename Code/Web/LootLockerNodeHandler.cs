using Godot;

public partial class LootLockerNodeHandler : Node
{
    private HttpRequest _auth_http;
    private HttpRequest _leaderboard_http;
    private HttpRequest _old_leaderboard_http;
    private HttpRequest _submit_score_http;
    private HttpRequest _set_name_http;
    private HttpRequest _get_name_http;


    public HttpRequest AuthHTTP => _auth_http;
    public HttpRequest LeaderboardHTTP => _leaderboard_http;
    public HttpRequest OldLeaderboardHTTP => _old_leaderboard_http;
    public HttpRequest SubmitScoreHTTP => _submit_score_http;
    public HttpRequest SetNameHTTP => _set_name_http;
    public HttpRequest GetNameHTTP => _get_name_http;


    public override void _Ready()
    {
        _auth_http = new HttpRequest();
        _leaderboard_http = new HttpRequest();
        _old_leaderboard_http = new HttpRequest();
        _submit_score_http = new HttpRequest();
        _set_name_http = new HttpRequest();
        _get_name_http = new HttpRequest();

        AddChild(_auth_http);
        AddChild(_leaderboard_http);
        AddChild(_old_leaderboard_http);
        AddChild(_submit_score_http);
        AddChild(_set_name_http);
        AddChild(_get_name_http);

        LootLockerClient.NodeHandler = this;

        LootLockerClient.Authentication();
    }

    public override void _ExitTree()
    {
        _auth_http.CancelRequest();
        _leaderboard_http.CancelRequest();
        _old_leaderboard_http.CancelRequest();
        _submit_score_http.CancelRequest();
        _set_name_http.CancelRequest();
        _get_name_http.CancelRequest();


        LootLockerClient.NodeHandler = null;
    }
}