-- Selects all posts longer than the average post length

-- EXPLAIN ANALYZE
SELECT 
    p.id,
    p.title,
    LENGTH(p.body) AS body_size
FROM posts p
WHERE LENGTH(p.body) > (
    SELECT AVG(LENGTH(body)) 
    FROM posts
);