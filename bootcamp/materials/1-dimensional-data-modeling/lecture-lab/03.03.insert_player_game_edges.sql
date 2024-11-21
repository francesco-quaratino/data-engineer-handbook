INSERT INTO edges
WITH deduped AS (
    SELECT *, row_number() over (PARTITION BY player_id, game_id) AS row_num
    FROM game_details
)
SELECT
    player_id AS subject_identifier,
    'player'::vertex_type as subject_type,
    game_id AS object_identifier,
    'game'::vertex_type AS object_type,
    'plays_in'::edge_type AS edge_type,
    json_build_object(
        'start_position', start_position,
        'pts', pts,
        'team_id', team_id,
        'team_abbreviation', team_abbreviation
        ) as properties
FROM deduped
WHERE row_num = 1;


SELECT
    v.properties->>'player_name',
    MAX((e.properties->>'pts')::INTEGER) AS max_pts
FROM vertices v 
JOIN edges e 
    ON v.identifier = e.subject_identifier 
    AND v."type" = e.subject_type
GROUP BY 
    1
HAVING 
    MAX((e.properties->>'pts')::INTEGER) > 0
ORDER BY 
    2 DESC