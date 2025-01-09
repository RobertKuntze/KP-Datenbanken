WITH parentids AS (
	SELECT a.parentid FROM posts a WHERE a.parentid IS NOT NULL
)
SELECT
	u.id,
	u.displayname,
	ARRAY_AGG((p.id, p.title, p.body)) as post
FROM users u
JOIN posts p
ON u.displayname = p.ownerdisplayname
WHERE p.parentid IS NULL
AND p.id NOT IN (SELECT * FROM parentids)
AND EXTRACT(YEAR FROM p.creationdate) = 2012
AND u.displayname != 'Community'
GROUP BY u.displayname, u.id
