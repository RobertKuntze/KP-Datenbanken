-- EXPLAIN ANALYZE
CREATE MATERIALIZED VIEW IF NOT EXISTS AnswersViewMat AS (
	SELECT DISTINCT
		u.id, 
		u.displayname, 
		u2.id AS answer_id, 
		u2.displayname AS answer_name
	FROM users u
	JOIN posts p ON u.id = p.owneruserid
	JOIN posts a ON p.id = a.parentid
	JOIN users u2 ON a.owneruserid = u2.id AND u2.id != u.id
);

-- EXPLAIN ANALYZE
REFRESH MATERIALIZED VIEW AnswersViewMat;


-- EXPLAIN ANALYZE
SELECT a1.displayname, a2.displayname
FROM AnswersViewMat a1
JOIN AnswersViewMat a2 
ON a1.id = a2.answer_id
AND a2.id = a1.answer_id
-- no inverse tuples
AND a1.id > a2.id;