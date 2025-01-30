-- Selects users who have a post with a score and commentcount higher than the average of all posts
EXPLAIN ANALYZE
SELECT
    id,
    displayname
FROM users
WHERE id IN (
    SELECT DISTINCT owneruserid
    FROM posts
    WHERE score > (
        SELECT avg(score)
        FROM posts
    )
    AND commentcount > (
        SELECT avg(commentcount)
        FROM posts
    )
    GROUP BY owneruserid
)
ORDER BY id;