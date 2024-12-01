-- SELECT all post ids and their comment ids in a json array
-- seems to be slightly slower than an array agg

EXPLAIN ANALYZE
SELECT p.id, json_agg(c.id)
FROM posts p
JOIN comments c ON p.id = c.postid
GROUP BY p.id