-- Ranks the answers by score within each post
EXPLAIN ANALYZE
SELECT 
    p1.parentid,
    p1.id,
    p1.score,
    count(p2.score) AS rank
FROM posts p1
LEFT JOIN 
    posts p2 ON p1.parentid = p2.parentid 
    AND p2.score > p1.score
WHERE p1.posttypeid = 2
GROUP BY p1.parentid, p1.id, p1.score
ORDER BY p1.parentid, p1.score DESC;