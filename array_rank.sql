-- Calculates each user's months with highest posts, upvotes and downvotes counts

-- EXPLAIN ANALYZE
WITH posts_per_month AS (
    SELECT
        TO_CHAR(p.creationdate, 'YYYY-MM') AS year_month,
        u.id AS uid,
        COUNT(*) AS num_posts,
        RANK() OVER (PARTITION BY u.id ORDER BY COUNT(*) DESC) AS rank
    FROM users u
    JOIN posts p ON p.owneruserid = u.id
    GROUP BY TO_CHAR(p.creationdate, 'YYYY-MM'), u.id
),
upvotes_per_month AS (
    SELECT
        TO_CHAR(v.creationdate, 'YYYY-MM') AS year_month,
        u.id AS uid,
        COUNT(*) AS num_votes,
        RANK() OVER (PARTITION BY u.id ORDER BY COUNT(*) DESC) AS rank
    FROM users u
    JOIN posts p ON p.owneruserid = u.id
    JOIN votes v ON v.postid = p.id
    WHERE v.votetypeid = 2
    GROUP BY TO_CHAR(v.creationdate, 'YYYY-MM'), u.id
),
downvotes_per_month AS (
    SELECT
        TO_CHAR(v.creationdate, 'YYYY-MM') AS year_month,
        u.id AS uid,
        COUNT(*) AS num_votes,
        RANK() OVER (PARTITION BY u.id ORDER BY COUNT(*) DESC) AS rank
    FROM users u
    JOIN posts p ON p.owneruserid = u.id
    JOIN votes v ON v.postid = p.id
    WHERE v.votetypeid = 5
    GROUP BY TO_CHAR(v.creationdate, 'YYYY-MM'), u.id
)
SELECT
    u.id,
    (
        SELECT
            p.year_month
        FROM posts_per_month p
        WHERE p.uid = u.id
        AND rank <= 1
        ORDER BY num_posts
        LIMIT 1
    ) most_posts,
    (
        SELECT
            p.year_month
        FROM upvotes_per_month p
        WHERE p.uid = u.id
        AND rank <= 1
        ORDER BY num_votes
        LIMIT 1
    ) most_upvotes,
    (
        SELECT
            p.year_month
        FROM downvotes_per_month p
        WHERE p.uid = u.id
        AND rank <= 1
        ORDER BY num_votes
        LIMIT 1
    ) most_downvotes
FROM users u;