-- select all users + posts that have no answers and were posted in 2012

WITH parentids AS (
	SELECT a.parentid FROM posts a WHERE a.parentid IS NOT NULL
)
SELECT
	u.id,
	u.displayname,
	ARRAY_AGG((p.id, p.title, p.body)) as post
FROM users u
JOIN posts p
ON u.id = p.owneruserid
WHERE p.parentid IS NULL
AND p.id NOT IN (SELECT * FROM parentids)
AND EXTRACT(YEAR FROM p.creationdate) = 2012
AND u.id != -1 -- public community user
GROUP BY u.id
