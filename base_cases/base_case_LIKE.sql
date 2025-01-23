-- SELECT posts that have the dataset tag and linked to a post that doesn't have it

EXPLAIN ANALYZE
SELECT p1.creationdate, p2.creationdate, p1.tags, p2.tags
FROM posts p1
JOIN postlinks pl ON p1.id = pl.postid
JOIN posts p2 ON pl.relatedpostid = p2.id
AND p1.tags LIKE '%dataset%'
AND NOT p2.tags LIKE '%dataset%'