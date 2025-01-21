-- Calculates the number of posts, average length and average time difference
-- between consecutive posts and comments for each month

-- EXPLAIN ANALYZE
WITH posts_date_table AS (
    SELECT
        TO_CHAR(posts.creationdate, 'YYYY-MM') AS year_month,
        creationdate - LAG(creationdate) OVER (ORDER BY creationdate) AS time_diff,
        LENGTH(posts.body) AS length
    FROM posts
),
comments_date_table AS (
    SELECT
        TO_CHAR(comments.creationdate, 'YYYY-MM') AS year_month,
        creationdate - LAG(creationdate) OVER (ORDER BY creationdate) AS time_diff,
        LENGTH(comments.text) AS length
    FROM comments
),
postings_date_table AS (
    SELECT
        year_month,
        time_diff,
        length
    FROM posts_date_table
    UNION ALL
    SELECT
        year_month,
        time_diff,
        length
    FROM comments_date_table
    ORDER BY year_month
)
SELECT
    year_month,
    COUNT(*) AS num_postings,
    AVG(time_diff) AS avg_time_diff,
    AVG(length) AS avg_length
FROM postings_date_table
GROUP BY year_month;