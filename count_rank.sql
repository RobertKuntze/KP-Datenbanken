-- Ranks users by the number of posts they have made

-- EXPLAIN ANALYZE
SELECT
    u.id,
    displayname,
    COUNT(*) AS post_count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank
FROM users u
JOIN posts p ON p.owneruserid = u.id
GROUP BY u.id;