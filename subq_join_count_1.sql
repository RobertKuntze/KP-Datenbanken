-- Counts the number of post changes each user has made
EXPLAIN ANALYZE
SELECT
    u.id,
    u.displayname,
    (
        SELECT count(*)
        FROM posthistory p
        WHERE p.userid = u.id
    ) as post_change_count
FROM users u