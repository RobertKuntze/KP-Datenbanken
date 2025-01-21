-- Select the month with the most new users for each year

-- EXPLAIN ANALYZE
WITH users_per_month AS (
    SELECT
        EXTRACT(YEAR FROM creationdate) AS year,
        EXTRACT(MONTH FROM creationdate) AS month,
        COUNT(*) AS new_users_count,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM creationdate) ORDER BY COUNT(*) DESC) AS month_rank
    FROM users
    GROUP BY year, month
)
SELECT
    year,
    month,
    new_users_count
FROM users_per_month
WHERE month_rank = 1;