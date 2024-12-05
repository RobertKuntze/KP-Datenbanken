-- SELECT amount of commentsfor posts that link (quite arbitrary)

EXPLAIN ANALYZE
SELECT p1.id, u.id, p2.id, count(c.id)
FROM users u
JOIN posts p1 ON p1.owneruserid = u.id
JOIN postlinks pl ON pl.postid = p1.id
JOIN posts p2 ON p2.id = pl.relatedpostid
JOIN comments c ON p1.id = c.postid
WHERE u.creationdate <= '2013-01-01'
AND p1.creationdate >= '2013-01-01'
AND p2.creationdate <= '2013-01-01'
GROUP BY (p1.id, u.id, p2.id)
