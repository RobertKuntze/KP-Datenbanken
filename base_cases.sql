EXPLAIN ANALYZE

SELECT u.creationdate, p1.creationdate, p2.creationdate, pl.id
FROM users u
JOIN posts p1 ON p1.owneruserid = u.id
JOIN postlinks pl ON pl.postid = p1.id
JOIN posts p2 ON p2.id = pl.relatedpostid
WHERE u.creationdate <= '2013-01-01'
AND p1.creationdate >= '2013-01-01'
AND p2.creationdate <= '2013-01-01'
ORDER BY u.creationdate DESC

EXPLAIN ANALYZE

SELECT p1.creationdate, p2.creationdate, p1.tags, p2.tags
FROM posts p1
JOIN postlinks pl ON p1.id = pl.postid
JOIN posts p2 ON pl.relatedpostid = p2.id
AND p1.tags ~ 'dataset'
AND NOT p2.tags ~ 'dataset'

EXPLAIN ANALYZE

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

EXPLAIN ANALYZE

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

EXPLAIN ANALYZE

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

