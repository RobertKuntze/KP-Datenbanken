-- count good and bad answers, group by year & month; show best and worst user
--EXPLAIN ANALYZE
WITH answersYMHelper AS 
(
	SELECT *,
		EXTRACT(YEAR FROM creationdate) as "year",
		EXTRACT(MONTH FROM creationdate) as "month"
	FROM posts
	WHERE parentid IS NOT NULL
),
answersYM AS (
	SELECT * FROM answersYMHelper
	WHERE "year" > 2010
	OR ("year" = 2010 AND "month" >= 7) 
),
avgs AS
(
	SELECT
		"year", "month",
		AVG(score) as "avg"
	FROM answersYM
	GROUP BY "year", "month"
),
answers AS (
	SELECT
		p."id", p.score, a.year, a.month, u.displayname, a.avg,
		CASE 
			WHEN p.score >= a.avg THEN 1
			ELSE 0
		END AS score_type
	FROM answersYM p
	JOIN avgs a
		ON (p.year = a.year AND p.month = a.month)
	JOIN users u
		ON u.id = p.owneruserid
	ORDER BY p.year, p.month, score DESC
)
SELECT 
	a.year, a.month,
	COUNT(*) AS all_answers,
	SUM(score_type) AS good_answers,
	COUNT(*) - SUM(score_type) AS bad_answers,
	(
		SELECT displayname
		FROM answers a2 
		WHERE a2.year = a.year 
		AND (a2.month = a.month OR a.month IS NULL)
		ORDER BY a2.score DESC
		LIMIT 1
	) as top_user,
	MAX(score) AS highest_score,
	(
		SELECT displayname
		FROM answers a2 
		WHERE a2.year = a.year 
		AND (a2.month = a.month OR a.month IS NULL)
		ORDER BY a2.score
		LIMIT 1
	) as worst_users,
	MIN(score) AS lowest_score
FROM answers a
GROUP BY
	GROUPING SETS 
	(
		("year", "month"),
		("year")
	)
ORDER BY "year", "month"


