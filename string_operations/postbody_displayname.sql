EXPLAIN ANALYZE
WITH postbody AS (
    SELECT id, array_remove(regexp_split_to_array(regexp_replace(body, '<[^>]+>', '', 'g'), '\W+'), '') as words
    FROM posts
),
originalPosts AS (
    SELECT *
    FROM posts
    WHERE posttypeid = 1
)
SELECT op.id original_post_id, u.id user_id, p.id post_id, words, u.displayname
FROM posts p
JOIN postbody pb ON p.id = pb.id
JOIN originalPosts op ON p.parentid = op.id
JOIN users u ON op.owneruserid = u.id
WHERE u.displayname = ANY(pb.words)
ORDER BY cardinality(words) ASC
