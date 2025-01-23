-- count of all different words in post bodies

EXPLAIN ANALYZE
WITH postbody AS (
    SELECT id, unnest(array_remove(regexp_split_to_array(regexp_replace(body, '<[^>]+>', '', 'g'), '\W+'), '')) as words
    FROM posts
)
SELECT words, count(*) count
FROM postbody
GROUP BY words
ORDER BY count DESC