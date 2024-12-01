-- SELECT all post ids and their comment ids in an array

EXPLAIN ANALYZE
SELECT p.id, array_agg(c.id)
FROM posts p
JOIN comments c ON p.id = c.postid
GROUP BY p.id
