-- Selects all posts created by users, who received the 'Teacher' badge after 2012
EXPLAIN ANALYZE
SELECT
    p.id,
    p.body
FROM posts p
WHERE p.owneruserid IN (
    SELECT userid
    FROM badges
    WHERE
        name = 'Teacher'
        AND date >= '2013-01-01'
);