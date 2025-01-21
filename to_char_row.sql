-- Select the most popular tag for each month

-- EXPLAIN ANALYZE
WITH date_table AS (
    SELECT
        TO_CHAR(p.creationdate, 'YYYY-MM') AS year_month,
        t.tagname AS tag,
        ROW_NUMBER() OVER (PARTITION BY TO_CHAR(p.creationdate, 'YYYY-MM') ORDER BY COUNT(*) DESC) AS row,
        COUNT(*) AS post_count
    FROM posts p
    JOIN tags t ON p.tags LIKE CONCAT('%', '<', t.tagname, '>', '%')
    GROUP BY TO_CHAR(p.creationdate, 'YYYY-MM'), t.tagname
),
monthly_totals AS (
    SELECT
        TO_CHAR(creationdate, 'YYYY-MM') AS year_month,
        COUNT(*) AS monthly_posts
    FROM posts
    GROUP BY TO_CHAR(creationdate, 'YYYY-MM')
)
SELECT
    d.year_month,
    d.tag,
    d.post_count,
    m.monthly_posts
FROM date_table d
JOIN monthly_totals m ON m.year_month = d.year_month
WHERE d.row = 1;