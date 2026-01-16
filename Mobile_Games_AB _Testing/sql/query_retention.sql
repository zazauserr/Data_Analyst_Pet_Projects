WITH user_activity AS (
        SELECT 
        userid,
        version,
        SUM(sum_gamerounds) as total_rounds,
        MAX(retention_1) as ret_1,
        MAX(retention_7) as ret_7
    FROM game_events
    GROUP BY 1, 2
)
SELECT * FROM user_activity
WHERE total_rounds < 10000