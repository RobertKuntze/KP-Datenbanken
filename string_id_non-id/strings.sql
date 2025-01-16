-- wrong road with unnessecary string casts
WITH parentids AS (
	SELECT STRING_AGG(a.parentid::TEXT, ',')
	FROM posts a
	WHERE a.parentid::TEXT IS NOT NULL
)
SELECT
	u.id::TEXT,
	u.displayname::TEXT,
	ARRAY_AGG(p.id::TEXT || ', ' || p.title || ', ' || p.body) as post
FROM users u
JOIN posts p
ON u.displayname::TEXT = p.ownerdisplayname::TEXT
-- ON u.id::TEXT = p.owneruserid::TEXT
WHERE p.parentid::TEXT IS NULL
AND (SELECT * FROM parentids) ~~ ('%' || p.id::TEXT || '%')
AND p.creationdate::TEXT ~~ '2012%'
AND u.displayname != 'Community'
GROUP BY u.displayname::TEXT, u.id::TEXT
