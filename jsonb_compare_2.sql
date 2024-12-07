-- get posts and all their answers that have a higher score as a json
-- almost the same cost, but way faster execution
-- -> cost estimation for jsons seems incorrect

EXPLAIN ANALYZE
WITH answers AS
(
    SELECT *
    FROM posts
    WHERE posttypeid = 2
)
SELECT p1.id, json_agg(row_to_json(a))
FROM posts p1
JOIN answers a ON p1.id = a.parentid
WHERE a.score >= p1.score
GROUP BY p1.id
