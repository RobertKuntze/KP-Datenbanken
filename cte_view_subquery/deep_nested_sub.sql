-- Nesting subqueries with WHERE clauses and unnecessary CROSS JOINs

-- EXPLAIN ANALYZE
SELECT DISTINCT
    p.pid,
    p.uid
FROM (
    SELECT DISTINCT
        p.pid,
        p.uid,
        p.owneruserid,
        p.score
    FROM (
        SELECT DISTINCT
            p.pid,
            p.uid,
            p.owneruserid,
            p.score,
            p.answercount
        FROM (
            SELECT DISTINCT
                p.pid,
                p.uid,
                p.owneruserid,
                p.score,
                p.answercount,
                p.viewcount
            FROM (
                SELECT DISTINCT
                    p.pid,
                    p.uid,
                    p.owneruserid,
                    p.score,
                    p.answercount,
                    p.viewcount,
                    p.tags
                FROM (
                    SELECT DISTINCT
                        u.id AS uid,
                        p.id AS pid,
                        p.owneruserid,
                        p.score,
                        p.answercount,
                        p.viewcount,
                        p.tags,
                        p.acceptedanswerid
                    FROM posts p
                    CROSS JOIN users u
                ) p
                CROSS JOIN users u
                WHERE p.acceptedanswerid IS NOT NULL
            ) p
            CROSS JOIN users u
            WHERE p.tags LIKE '%python%'
        ) p
        CROSS JOIN users u
        WHERE p.viewcount > 0
    ) p
    CROSS JOIN users u
    WHERE p.answercount > 0
) p
CROSS JOIN users u
WHERE p.owneruserid = p.uid
AND p.score > 0;