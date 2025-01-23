EXPLAIN ANALYZE
SELECT
    extract(YEAR FROM v.creationdate) as Year,
    p.posttypeid,
    v.votetypeid,
    COUNT(v.id) votecount
FROM votes v
JOIN posts p ON v.postid = p.id
GROUP BY GROUPING SETS (
    ROLLUP(Year, p.posttypeid, v.votetypeid)
)