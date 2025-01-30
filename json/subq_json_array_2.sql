-- Selects the top 3 scored answers for each post, in a JSON array
EXPLAIN ANALYZE
SELECT 
    p.id,
    json_array(
        SELECT a.body
        FROM posts a
        WHERE a.parentid = p.id
        ORDER BY a.score DESC
        LIMIT 3
    ) AS top_answers
FROM posts p