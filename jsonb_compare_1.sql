--EXPLAIN ANALYZE
WITH answers AS
(
    SELECT row_to_json(posts)::jsonb answer
    FROM posts
    WHERE posttypeid = 2
)
SELECT p1.id, jsonb_agg(a.answer)
FROM posts p1
JOIN answers a ON p1.id = (a.answer->>'parentid')::int
WHERE (a.answer->>'score')::int >= p1.score
GROUP BY p1.id
