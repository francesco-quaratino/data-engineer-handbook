

SELECT * FROM players
WHERE player_name = 'Michael Jordan'
ORDER BY current_season;


SELECT player_name, 
    (UNNEST(season_stats)::season_stats).*
FROM players
WHERE current_season = 2001
    AND player_name = 'Michael Jordan';


WITH players_performance AS (
    SELECT player_name, 
        (season_stats[1]::season_stats).pts             AS first_season_pts,
        (season_stats[CARDINALITY(season_stats)]).pts   AS latest_season_pts
    FROM players
    WHERE current_season = 2001
    AND scoring_class = 'star'
)
SELECT player_name,
    latest_season_pts / 
        CASE first_season_pts 
            WHEN 0 THEN 1 
            ELSE first_season_pts 
        END                                             AS ratio_most_recent_to_first
FROM players_performance
ORDER BY 
    2 DESC