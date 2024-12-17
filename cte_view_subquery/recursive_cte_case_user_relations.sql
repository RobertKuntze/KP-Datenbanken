-- EXPLAIN ANALYZE
WITH RECURSIVE userRelations AS 
(
	(
		SELECT "id" as userid, displayname, 0 as "depth"
		FROM users
		WHERE "id" != -1
		ORDER BY upvotes DESC, "id"
		LIMIT 1
	)
	UNION
	(
		SELECT DISTINCT u.id as userid, u.displayname, (r.depth + 1) as "depth"
		FROM userRelations r
		JOIN posts p ON p.owneruserid = r.userid
		JOIN posts p2 ON p2.parentid = p.id
		JOIN users u ON p2.owneruserid = u.id
		WHERE r.depth < 5
	)
)
CYCLE userid, displayname
	SET cyclic
	USING "path"
SELECT userid, displayname, "depth", ARRAY_TO_JSON("path") as path_json
FROM userRelations
WHERE NOT cyclic
ORDER BY "depth", userid