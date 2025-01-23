-- Selects every answer that mentions a user from a previous answer

-- EXPLAIN ANALYZE
SELECT
    u.id,
    u.displayname,
    a1.body,
    a2.body
FROM users u
JOIN posts a1 ON a1.owneruserid = u.id
JOIN posts a2 ON a2.body LIKE CONCAT('%', u.displayname, '%')
WHERE a1.parentid = a2.parentid
AND a1.creationdate < a2.creationdate 
ORDER BY a1.creationdate DESC;