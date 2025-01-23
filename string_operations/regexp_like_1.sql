-- Selects all posts having comments with links in them, but the post itself doesn't

-- EXPLAIN ANALYZE
SELECT
    p.id,
    p.body,
    c.text
FROM posts p
JOIN comments c ON c.postid = p.id
WHERE c.text LIKE '%https://%'
AND p.body NOT LIKE '%https://%';