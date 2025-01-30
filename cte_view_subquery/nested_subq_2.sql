-- Selects users who have a post with a score and commentcount higher than the average of all posts
EXPLAIN ANALYZE
SELECT DISTINCT
    u.id,
    u.displayname
FROM users u
INNER JOIN posts p ON p.owneruserid = u.id
WHERE p.score > (
    SELECT avg(score)
    FROM posts
)
AND p.commentcount > (
    SELECT avg(commentcount)
    FROM posts
)
ORDER BY u.id;