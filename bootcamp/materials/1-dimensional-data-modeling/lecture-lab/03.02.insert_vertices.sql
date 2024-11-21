--GAME
INSERT INTO vertices 
SELECT 
    game_id AS indentifier,
    'game'::vertex_type AS TYPE,
    json_build_object(
        'pts_home', pts_home,
        'pts_away', pts_away,
        'winning_team', CASE WHEN home_team_wins = 1 THEN home_team_id ELSE visitor_team_id END
    ) AS properties
FROM games

--PLAYER
INSERT INTO vertices
WITH players_agg AS (
    SELECT 
        player_id                   AS identifier,
        MIN(player_name)            AS player_name,
        COUNT(1)                    AS number_of_games,
        SUM(pts)                    AS total_points,
        array_agg(DISTINCT team_id) AS teams 
    FROM game_details gd 
    GROUP BY player_id
)
SELECT 
    identifier,
    'player'::vertex_type AS type,
    jsonb_build_object(
        'player_name', player_name,
        'number_of_games', number_of_games,
        'total_points, total_points,'
        'teams', teams
    ) AS properties 
FROM players_agg


--TEAM
INSERT INTO vertices
SELECT DISTINCT
	team_id AS indentifier,
	'team'::vertex_type AS TYPE,
	jsonb_build_object(
		'abbreviation', abbreviation,
		'nickname', nickname,
		'city', city,
		'arena', arena,
		'year_founded', yearfounded
	) AS properties 
FROM teams