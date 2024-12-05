-- SELECT posts that were created after 2012, by users created earlier than 2013 that link to a post made before 2013

EXPLAIN ANALYZE
SELECT p1.id, u.id, p2.id, array_agg(c.id)
FROM users u
JOIN posts p1 ON p1.owneruserid = u.id
JOIN postlinks pl ON pl.postid = p1.id
JOIN posts p2 ON p2.id = pl.relatedpostid
JOIN comments c ON p1.id = c.postid
WHERE u.creationdate <= '2013-01-01'
AND p1.creationdate >= '2013-01-01'
AND p2.creationdate <= '2013-01-01'
GROUP BY (p1.id, u.id, p2.id)