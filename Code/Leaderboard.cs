using Godot;
using System;

public partial class Leaderboard : Control
{
    [Export]
    private RichTextLabel _leaderboardsContainer;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        LootLockerClient.GetLeaderboardsCompleted += SetLeaderboards;
        GetLeaderboards();
    }

    public async void GetLeaderboards() 
    {
        await ToSignal(GetTree().CreateTimer(3), "timeout");

        LootLockerClient.GetLeaderboards();
    }

    public override void _ExitTree()
    {
        LootLockerClient.GetLeaderboardsCompleted -= SetLeaderboards;
    }

    public void SetLeaderboards(LeaderboardData[] data)
    {
        var leaderboard_cells = $"[cell]{"Ранг"}[/cell][cell]        {"Игрок"}        [/cell][cell]Количество очков[/cell]";

        foreach (var item in data)
        {
            leaderboard_cells += $"[cell][right]{item.Rank}.[/right][/cell]";
            leaderboard_cells += $"[cell]{item.PlayerName}[/cell]";
            leaderboard_cells += $"[cell][left]{item.Score}[/left][/cell]";
        }

        _leaderboardsContainer.Text = $"[center][table=3]{leaderboard_cells}[/table]";
    }
}
