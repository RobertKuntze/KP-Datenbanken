CREATE MATERIALIZED VIEW IF NOT EXISTS LastInteractionsViewMat AS (
	SELECT DISTINCT
		u.id, 
		u.displayname, 
		u2.id AS answer_id, 
		u2.displayname AS answer_name,
		ROW_NUMBER() OVER (PARTITION BY u.id ORDER BY a.creationdate DESC) as rownum
	FROM users u
	JOIN posts p ON u.id = p.owneruserid
	JOIN posts a ON p.id = a.parentid
	JOIN users u2 ON a.owneruserid = u2.id AND u2.id != u.id
);

REFRESH MATERIALIZED VIEW LastInteractionsViewMat;

-- EXPLAIN ANALYZE 
SELECT displayname, ARRAY_AGG(answer_name) as last_interactions
FROM LastInteractionsViewMat
WHERE rownum <= 3
GROUP BY "id", displayname;

DROP MATERIALIZED VIEW LastInteractionsViewMat;