-- Ranks the answers by score within each post
EXPLAIN ANALYZE
SELECT 
    parentid,
    id,
    score,
    RANK() OVER (PARTITION BY parentid ORDER BY score DESC) AS Rank
FROM posts
WHERE posttypeid = 2;