-- Counts the number of post changes each user has made
EXPLAIN ANALYZE
SELECT
    u.id,
    u.displayname,
    count(*)
FROM users u
JOIN posthistory p ON p.userid = u.id
GROUP BY u.id