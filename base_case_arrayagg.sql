--EXPLAIN ANALYZE
WITH topcomments AS 
(
    SELECT id, postid
    FROM comments
    ORDER BY score DESC
)
SELECT p.id, array_agg(c.id)
FROM posts p
JOIN topcomments c ON p.id = c.postid
GROUP BY p.id
