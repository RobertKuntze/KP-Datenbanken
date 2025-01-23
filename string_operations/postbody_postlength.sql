EXPLAIN ANALYZE

WITH postbody AS (
    SELECT id, score, cardinality(array_remove(regexp_split_to_array(regexp_replace(body, '<[^>]+>', '', 'g'), '\W+'), '')) as wordcount
    FROM posts
)
SELECT avg(score) score, wordcount, count(wordcount) count
FROM postbody
GROUP BY GROUPING SETS (CUBE(wordcount))
ORDER BY count DESC