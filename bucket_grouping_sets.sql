-- Calculates the average views and upvotes for each bucket of views and upvotes

-- EXPLAIN ANALYZE
WITH max_values AS (
    SELECT
        MAX(views) AS max_views,
        MAX(upvotes) AS max_upvotes
    FROM users
),
user_stats AS (
    SELECT
        id,
        views,
        upvotes,
        CASE 
            WHEN views_bucket = 1 THEN 'low'
            WHEN views_bucket = 2 THEN 'medium'
            ELSE 'high'
        END AS views_ranking,
        CASE
            WHEN upvotes_bucket = 1 THEN 'low'
            WHEN upvotes_bucket = 2 THEN 'medium'
            ELSE 'high'
        END AS upvotes_ranking
    FROM (
        SELECT
            id,
            views,
            upvotes,
            width_bucket(views, 0, max_views, 3) AS views_bucket,
            width_bucket(upvotes, 0, max_upvotes, 3) AS upvotes_bucket
        FROM users
        CROSS JOIN max_values
    )
)
SELECT
    views_ranking,
    upvotes_ranking,
    AVG(views) AS avg_views,
    AVG(upvotes) AS avg_upvotes
FROM user_stats
GROUP BY  GROUPING SETS (
    (views_ranking, upvotes_ranking),
    (views_ranking),
    (upvotes_ranking),
    ()
);