EXPLAIN ANALYZE
SELECT avg(score) score, count(score) count, owneruserid
FROM posts 
WHERE owneruserid IS NOT NULL
GROUP BY GROUPING SETS (
    CUBE(owneruserid)
)
ORDER BY count DESC