--EXPLAIN ANALYZE
WITH answers AS
(
    SELECT *
    FROM posts
    WHERE posttypeid = 2
)
SELECT p1.id, jsonb_agg(row_to_json(a)::jsonb)
FROM posts p1
JOIN answers a ON p1.id = a.parentid
WHERE a.score >= p1.score
GROUP BY p1.id
